PImage cube, cubeNight;
PImage texFront, texBack, texLeft, texRight, texBottom, texTop;

void setupEnv() {
  cube = loadImage("..\\resources\\desert.png");
  cubeNight = loadImage("..\\resources\\night.jpg");
  cubeNightDay(false);
}

void updateLighting(boolean night) {
  if(night) { lightMoon(); }
  else { lightSun(); }
}

void lightMoon() {
  ambientLight(180, 180, 230);
  directionalLight(100, 100, 140, 0, 1000, -1);
}

void lightSun() {
  ambientLight(255, 255, 200);
  directionalLight(255, 255, 200, 0, -1000, -1);
}

void drawSkybox(float size) {
  noStroke();
  float d = size / 2;
  
  // Front
  normal(0, 0, -1);
  beginShape(QUADS);
  texture(texFront);
  vertex(-d, -d, -d, 0, 0);
  vertex( d, -d, -d, texFront.width, 0);
  vertex( d,  d, -d, texFront.width, texFront.height);
  vertex(-d,  d, -d, 0, texFront.height);
  endShape();

  // Back
  normal(0, 0, 1);
  beginShape(QUADS);
  texture(texBack);
  vertex( d, -d,  d, 0, 0);
  vertex(-d, -d,  d, texBack.width, 0);
  vertex(-d,  d,  d, texBack.width, texBack.height);
  vertex( d,  d,  d, 0, texBack.height);
  endShape();

  // Left
  normal(-1, 0, 0);
  beginShape(QUADS);
  texture(texLeft);
  vertex(-d, -d,  d, 0, 0);
  vertex(-d, -d, -d, texLeft.width, 0);
  vertex(-d,  d, -d, texLeft.width, texLeft.height);
  vertex(-d,  d,  d, 0, texLeft.height);
  endShape();

  // Right
  normal(1, 0, 0);
  beginShape(QUADS);
  texture(texRight);
  vertex( d, -d, -d, 0, 0);
  vertex( d, -d,  d, texRight.width, 0);
  vertex( d,  d,  d, texRight.width, texRight.height);
  vertex( d,  d, -d, 0, texRight.height);
  endShape();

  // Top
  normal(0, -1, 0);
  beginShape(QUADS);
  texture(texTop);
  vertex(-d, -d,  d, 0, 0);
  vertex( d, -d,  d, texTop.width, 0);
  vertex( d, -d, -d, texTop.width, texTop.height);
  vertex(-d, -d, -d, 0, texTop.height);
  endShape();

  // Bottom
  normal(0, 1, 0);
  beginShape(QUADS);
  texture(texBottom);
  vertex(-d,  d, -d, 0, 0);
  vertex( d,  d, -d, texBottom.width, 0);
  vertex( d,  d,  d, texBottom.width, texBottom.height);
  vertex(-d,  d,  d, 0, texBottom.height);
  endShape();
}

void cubeNightDay(boolean night) {
  PImage textureImage;
  if(night) {
    textureImage = loadImage("..\\resources\\night.jpg");
  } else {
    textureImage = loadImage("..\\resources\\desert.png");
  }
  
  int w = textureImage.width / 4;
  int h = textureImage.height / 3;

  texTop    = textureImage.get(w, 0, w, h);
  texLeft   = textureImage.get(0, h, w, h);
  texFront  = textureImage.get(w, h, w, h);
  texRight  = textureImage.get(2 * w, h, w, h);
  texBack   = textureImage.get(3 * w, h, w, h);
  texBottom = textureImage.get(w, 2 * h, w, h);
}