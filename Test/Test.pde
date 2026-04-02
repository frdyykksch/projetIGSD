Car car1;
PImage cube;
PImage texFront, texBack, texLeft, texRight, texBottom, texTop;

void setup() {
  size(800, 800, P3D);
  noStroke();

  cube = loadImage("..\\resources\\desert.png");
  car1 = new Car(50, -100, 100, 0, "..\\resources\\Car2.obj");
  
  int w = cube.width / 4;
  int h = cube.height / 3;

  texTop    = cube.get(w, 0, w, h);
  texLeft   = cube.get(0, h, w, h);
  texFront  = cube.get(w, h, w, h);
  texRight  = cube.get(2 * w, h, w, h);
  texBack   = cube.get(3 * w, h, w, h);
  texBottom = cube.get(w, 2 * h, w, h);

  setupCircuit();
}

void draw() {
  background(0);
  ambientLight(255, 255, 200);
  directionalLight(255, 255, 200, 0, -1000, -1);
  
  camera(width/2, height/2, 100, width/2, height/2, 0, 0, 1, 0);
  perspective(PI/2, float(width)/float(height), 1, 10000);
  translate(width/2, height/2);

  rotateY(frameCount * 0.01);

  car1.update();
  car1.display();

  drawSkybox(4000);
  // noLights();
  
  drawCircuit();
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