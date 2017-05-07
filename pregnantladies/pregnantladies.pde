float cx, cy; //<>//
float r;
PImage img;
PImage white;
PrintWriter output;
int startImgNum = 1;
int imgNum = startImgNum;
int endImgNum = 100;
int colorNum;
PFont f;

int numPointsDrawn = 0;

int w = 800;
int h = 800;
float p1x, p1y;
float p2x, p2y;
float p3x, p3y;
boolean goodForPoster = true;

int vSz = 6;

void setup() {
  output = createWriter("data.txt");
  output.println("image name, cx, cy, r, goodForPoster");
  f = createFont("Roboto-Medium", 22);
  size(800, 800);
  strokeWeight(2);
  img = loadImage(startImgNum + ".jpg");
  colorNum = floor(random(0, 1));
  white = loadImage("white.jpg");
  white.resize(w, h);
  if (img.width > img.height) {
    img.resize(w, 0);
  } else {
    img.resize(0, h);
  }
  image(white, 0, 0);
  image(img, 0, 0);
}

void mouseClicked() {
  if (numPointsDrawn < 3) {
    numPointsDrawn++;
    drawPoint(mouseX, mouseY);
    if (numPointsDrawn == 1) {
      p1x = mouseX;
      p1y = mouseY;
    } else if (numPointsDrawn == 2) {
      p2x = mouseX;
      p2y = mouseY;
    } else if (numPointsDrawn == 3) {
      p3x = mouseX;
      p3y = mouseY;
    }
  }
}

void mouseDragged() {
  if (mouseInPoint(mouseX, mouseY, p1x, p1y)) {
    p1x = mouseX;
    p1y = mouseY;
  } else if (mouseInPoint(mouseX, mouseY, p2x, p2y)) {
    p2x = mouseX;
    p2y = mouseY;
  } else if (mouseInPoint(mouseX, mouseY, p3x, p3y)) {
    p3x = mouseX;
    p3y = mouseY;
  }
}

boolean mouseInPoint(float x, float y, float px, float py) {
  int v = 20;
  if (x < px + v && x > px - v && y > py - v && y < py + v) {
    return true;
  } else {
    return false;
  }
}

void keyPressed() {
  if (key == 'f') {
    goodForPoster = false;
  }
  if (key == ' ') {
    if (numPointsDrawn == 3) {
       output.println(imgNum + ".jpg, " + cx + ", " + cy + ", " + r + ", " + goodForPoster);
       goodForPoster = true;
       save(imgNum + ".jpg");
    }  
    
    if (imgNum + 1 > endImgNum) {
      output.flush();  // Writes the remaining data to the file
      output.close();  // Finishes the file
      exit();
    }
    imgNum = imgNum + 1;
    img = loadImage("ladies/" + imgNum + ".jpg");
    if (img.width > img.height) {
      img.resize(w, 0);
    } else {
      img.resize(0, h);
    }
    image(white, 0, 0);
    image(img, 0, 0);
    numPointsDrawn = 0;
  }
}

void drawPoint(float x, float y) {
  fill(255, 173, 220);
  ellipseMode(RADIUS);
  ellipse(x, y, vSz, vSz);
}

void drawThreePoints() {
  line(cx, cy, p2x, p2y);
  fill(255, 173, 220);
 
  ellipseMode(RADIUS);
  ellipse(p1x, p1y, vSz, vSz);
  ellipse(p2x, p2y, vSz, vSz);
  ellipse(p3x, p3y, vSz, vSz);
  ellipse(cx, cy, vSz/2, vSz/2);

  textFont(f);
  fill(255, 255, 255, 180);
  strokeWeight(0);
  //rect(cx - 43, cy + 10, 88, 30, 5);
  fill(0);


  float diffY = p2y - cy;
  float diffX = p2x - cx;
  float orientationInRadians = atan2 (diffY, diffX); 
  if (p2x < cx) {
    orientationInRadians = PI + orientationInRadians;
  }
  float radiusCenterX = cx + diffX/2.0;
  float radiusCenterY = cy + diffY/2.0;

  float textOffsetFromRadius = 8;
  float textCenterX = radiusCenterX + sin(orientationInRadians)*textOffsetFromRadius; 
  float textCenterY = radiusCenterY - cos(orientationInRadians)*textOffsetFromRadius; 

  pushMatrix();
  translate(textCenterX, textCenterY);
  rotate(orientationInRadians);
  fill(0);
  textAlign(CENTER);
  text(nf(r, 0, 1), 0, 0); 
  popMatrix();
  
  text("(" + floor(cx) + ", " + floor(cy) + ")", cx, cy + 30);

  strokeWeight(2);
}

void getCircleFromPoints() {
  float ma = (p2y - p1y) / (p2x - p1x);
  float mb = (p3y - p2y) / (p3x - p2x);
  cx = (ma*mb*(p1y - p3y)+mb*(p1x+p2x)-ma*(p2x+p3x)) / (2*(mb-ma)); 
  cy = -1/ma * (cx - (p1x + p2x)/2) + (p1y + p2y) / 2;
  r = sqrt((p1x - cx) * (p1x - cx) + (p1y - cy) * (p1y - cy));
}


void draw() {
  if (numPointsDrawn == 3) {
    getCircleFromPoints();
    ellipseMode(RADIUS);
    image(img, 0, 0);
    fill(255, 173, 220, 100);
    ellipse(cx, cy, r, r);
    drawThreePoints();
  }
}