boolean isNight = false;
ArrayList<Car> cars;
Car car1;
Car car2;

void setup() {
  size(800, 800, P3D);
  noStroke();

  cars = new ArrayList<Car>();
  car1 = new Car(-600, 0, 0, "..\\resources\\Car2.obj");
  car2 = new Car(60, 0, 0, "..\\resources\\PoliceCar.obj");
  cars.add(car1);
  cars.add(car2);
  
  setupCircuit();
  setupEnv();
}

void draw() {
  background(0);
  
  for(Car c : cars) {
    c.update();
    c.display();
  }
  
  translate(width/2, height/2, 0);
  setupCamera(car1);

  updateLighting(isNight);
  drawSkybox(4000);
  noLights();
  
  drawCircuit();
}

void setupCamera(Car targetCar) {
  float camDistance = 100;
  float camHeight = 80;
  
  float camX = targetCar.pos.x - cos(targetCar.angle) * camDistance;
  float camY = targetCar.pos.y - camHeight;
  float camZ = targetCar.pos.z - sin(targetCar.angle) * camDistance;
  
  float lookAheadDist = 50;
  float lookX = targetCar.pos.x + cos(targetCar.angle) * lookAheadDist;
  float lookY = targetCar.pos.y;
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