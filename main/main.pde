boolean isNight = false;
Circuit circuitF1;
ArrayList<Car> cars;
Car car1;
Car car2;
float cameraHeight = 60;
float cameraDistance = 100;
float cameraPitch = 0;
float targetPitch = 0;

PVector startPos;

void setup() {
  size(800, 800, P3D);
  noStroke();
  
  setupEnv();
  circuitF1 = new Circuit();

  startPos = new PVector(-600, 0, 0);
  cars = new ArrayList<Car>();
  car1 = new Car(startPos.x, startPos.y, startPos.z, "..\\resources\\Car2.obj");
  car2 = new Car(60, 0, 0, "..\\resources\\PoliceCar.obj");
  cars.add(car1);
  cars.add(car2);
  car1.angle = circuitF1.getSpawnAngle();
}

void draw() {
  background(0);

  translate(width/2, height/2, 0);
  setupCamera(car1);
  updateLighting(isNight);
  drawSkybox(4000);
  
  for(Car c : cars) {
    c.update(circuitF1);
    c.display();
  }

  noLights();
  circuitF1.display();
}

void setupCamera(Car targetCar) {
  targetPitch = targetCar.isUp ? -0.2 : 0.0;
  cameraPitch = lerp(cameraPitch, targetPitch, 0.06);

  float targetHeight   = targetCar.isUp ? 40  : 60;
  float targetDistance = targetCar.isUp ? 80  : 100;

  cameraHeight   = lerp(cameraHeight,   targetHeight,   0.06);
  cameraDistance = lerp(cameraDistance, targetDistance, 0.06);

  float camX = targetCar.pos.x - cos(targetCar.angle) * cameraDistance;
  float camY = targetCar.pos.y - cameraHeight;
  float camZ = targetCar.pos.z - sin(targetCar.angle) * cameraDistance;

  float lookAheadDist = 50;
  float lookX = targetCar.pos.x + cos(targetCar.angle) * lookAheadDist;
  float lookY = targetCar.pos.y + cameraPitch * 200;
  float lookZ = targetCar.pos.z + sin(targetCar.angle) * lookAheadDist;

  camera(camX, camY, camZ, lookX, lookY, lookZ, 0, 1, 0);
  perspective(PI/2.5, float(width)/float(height), 1, 10000);
}

void keyPressed() {
  if(key == 'n' || key == 'N') {
    isNight = !isNight;
    cubeNightDay(isNight);
  }
  setControl(keyCode, true);
}

void keyReleased() {
  setControl(keyCode, false);
}

void setControl(int code, boolean state) {
  if(code == LEFT || code == 'a' || code == 'A')  car1.isLeft  = state;
  if(code == RIGHT || code == 'd' || code == 'D') car1.isRight = state;
  if(code == UP || code == 'w' || code == 'W')    car1.isUp    = state;
  if(code == DOWN || code == 's' || code == 'S')  car1.isDown  = state;
}