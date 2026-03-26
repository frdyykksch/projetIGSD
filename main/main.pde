PImage cube;
<<<<<<< Updated upstream
PImage cubeNight;
=======
// Camera cam;
>>>>>>> Stashed changes
PImage texFront, texBack, texLeft, texRight, texBottom, texTop;
PShape Front, Back, Left, Right, Bottom, Top;
boolean isNight = true;

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
  // cam = new Camera(0, -300, -200);
  noStroke();
  setupEnv();
  cubeNightDay(isNight);
}

void draw() {
  background(0);
  
  camera(width/2, height/2, 100, width/2, height/2, 0, 0, 1, 0);
  perspective(PI/3, float(width)/float(height), 1, 10000);
  translate(width/2, height/2);
  
  float angleY = frameCount * 0.01;
  rotateY(angleY);
  if (isNight) {
    ambientLight(180, 180, 230);
    drawCube(4000);
    noLights();
  } else {
    drawCube(4000);
  }
  if (isNight) {
    lightMoon();
  } else {
    lightSun();
  }
  translate(0, 25, 0);
<<<<<<< Updated upstream
=======

  // cam.update();
  // cam.applyToScene();
  // noCursor();

>>>>>>> Stashed changes
  drawCar();
  drawCar2();
  drawCircuit();
}

<<<<<<< Updated upstream
void keyPressed() {
  if (key == 'n' || key == 'N') {
    isNight = !isNight;
    cubeNightDay(isNight);
  }
}
=======
void drawCube(float s) {
  noStroke();
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

// void mouseMoved()   { cam.mouseMoved(); }
// void mouseDragged() { cam.mouseMoved(); }
// void keyPressed()   { cam.keyPressed(key);   }
// void keyReleased()  { cam.keyReleased(key);  }
>>>>>>> Stashed changes
