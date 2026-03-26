PImage cube;
PImage cubeNight;
PImage texFront, texBack, texLeft, texRight, texBottom, texTop;
PShape Front, Back, Left, Right, Bottom, Top;

void setup() {
  size(800, 800, P3D);
  cube = loadImage("..\\resources\\desert.png");
  cubeNight = loadImage("..\\resources\\desert.png");
  int w = cube.width / 4;
  int h = cube.height / 3;

  texTop    = cube.get(w, 0, w, h);
  texLeft   = cube.get(0, h, w, h);
  texFront  = cube.get(w, h, w, h);
  texRight  = cube.get(2 * w, h, w, h);
  texBack   = cube.get(3 * w, h, w, h);
  texBottom = cube.get(w, 2 * h, w, h);
  
  setupCar();
  setupCircuit();
  setupCar2();
  noStroke();
  setupEnv();
  cubeNightDay(false);
}

void draw() {
  background(0);
  
  camera(width/2, height/2, 100, width/2, height/2, 0, 0, 1, 0);
  perspective(PI/3, float(width)/float(height), 1, 10000);
  translate(width/2, height/2);
  
  float angleY = frameCount * 0.01;
  rotateY(angleY);
  ambientLight(180, 180, 230);
  drawCube(4000);
  noLights();
  lightMoon();
  translate(0, 25, 0);
  drawCar();
  drawCar2();
  drawCircuit();
}