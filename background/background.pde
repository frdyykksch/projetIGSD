PImage cube;
PImage texFront, texBack, texLeft, texRight, texBottom, texTop;
PShape Front, Back, Left, Right, Bottom, Top;

void setup() {
  size(600, 600, P3D);
  cube = loadImage("C:\\Users\\frede\\Desktop\\Code\\UPS\\IGSD\\Projet\\projetIGSD\\resources\\desert.png");

  int w = cube.width / 4;
  int h = cube.height / 3;

  texTop    = cube.get(w, 0, w, h);
  texLeft   = cube.get(0, h, w, h);
  texFront  = cube.get(w, h, w, h);
  texRight  = cube.get(2 * w, h, w, h);
  texBack   = cube.get(3 * w, h, w, h);
  texBottom = cube.get(w, 2 * h, w, h);
  
  setupCar();
  noStroke();
}

void draw() {
  background(0);
  
  camera(70.0, 35.0, 120.0, 50.0, 50.0, 0.0, 0.0, 1.0, 0.0);
  
  // float angleY = frameCount * 0.01; 
  // xrotateY(angleY);
  
  drawCube(2000);
  drawCar();
}

void drawCube(float s) {
  float d = s / 2;

  // Front
  beginShape(QUADS);
  texture(texFront);
  vertex(-d, -d, -d, 0, 0);
  vertex( d, -d, -d, texFront.width, 0);
  vertex( d,  d, -d, texFront.width, texFront.height);
  vertex(-d,  d, -d, 0, texFront.height);
  endShape();

  // Face Arrière
  beginShape(QUADS);
  texture(texBack);
  vertex( d, -d,  d, 0, 0);
  vertex(-d, -d,  d, texBack.width, 0);
  vertex(-d,  d,  d, texBack.width, texBack.height);
  vertex( d,  d,  d, 0, texBack.height);
  endShape();

  // Left
  beginShape(QUADS);
  texture(texLeft);
  vertex(-d, -d,  d, 0, 0);
  vertex(-d, -d, -d, texLeft.width, 0);
  vertex(-d,  d, -d, texLeft.width, texLeft.height);
  vertex(-d,  d,  d, 0, texLeft.height);
  endShape();

  // Right
  beginShape(QUADS);
  texture(texRight);
  vertex( d, -d, -d, 0, 0);
  vertex( d, -d,  d, texRight.width, 0);
  vertex( d,  d,  d, texRight.width, texRight.height);
  vertex( d,  d, -d, 0, texRight.height);
  endShape();

  // Top
  beginShape(QUADS);
  texture(texTop);
  vertex(-d, -d,  d, 0, 0);
  vertex( d, -d,  d, texTop.width, 0);
  vertex( d, -d, -d, texTop.width, texTop.height);
  vertex(-d, -d, -d, 0, texTop.height);
  endShape();

  // Bottom
  beginShape(QUADS);
  texture(texBottom);
  vertex(-d,  d, -d, 0, 0);
  vertex( d,  d, -d, texBottom.width, 0);
  vertex( d,  d,  d, texBottom.width, texBottom.height);
  vertex(-d,  d,  d, 0, texBottom.height);
  endShape();
}
