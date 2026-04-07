import processing.sound.*;

Environment environment;
Circuit circuitF1;
ArrayList<Car> cars;
ArrayList<Police> carsPolice;
Car car1;
Minimap minimap;
Camera camera;
GUI gui;
Props props;
boolean isNight = false;
PVector startPos;
PVector endPos;

boolean firstPerson = false;

void setup() {
  size(800, 800, P3D);
  noStroke();

  environment = new Environment(isNight);
  circuitF1 = new Circuit();
  cars = new ArrayList<Car>();
  carsPolice = new ArrayList<Police>();

  startPos = circuitF1.getSpawnPoint();
  endPos = circuitF1.getLastPoint();
  float startYaw = circuitF1.getSpawnYaw();
  car1 = new Car(this, startPos.x, startPos.y, startPos.z, startYaw, "..\\resources\\mainCar2\\insideCar.obj");
  cars.add(car1);
  
  Police car2 = new Police(this, endPos.x, endPos.y, endPos.z, startYaw, "..\\resources\\PoliceCar.obj");
  carsPolice.add(car2);
  
  camera = new Camera(car1);
  gui = new GUI(car1);
  props = new Props(this, startPos.x, startPos.y-1, startPos.z, 20, "../resources/finish/BannerStartEnd.obj");

  minimap = new Minimap(circuitF1);
  minimap.drawCircuitMap(250, -100, -100);
  circuitF1.setupCircuit();
}

void draw() {
  background(0);
  pushMatrix();
  translate(width / 2, height / 2, 0);
  camera.update();
  environment.drawSkybox(8000);
  environment.updateLighting(isNight);
  circuitF1.lightCircuit(isNight);

  for(Car c : cars) {
    c.backLights();
    c.frontLights();
  }
  for(Police cp : carsPolice) {
    cp.backLights();
    cp.frontLights();
  }
  circuitF1.display();
  environment.drawSkybox(32000);
  
  // Draw banner at start position
  props.drawBanner();

  for(Car c : cars) {
    c.update(circuitF1);
    c.checkBannerCollision(startPos);
    c.display();
  }

  for(Police cp : carsPolice) {
    cp.update(circuitF1, car1);
    cp.checkBannerCollision(startPos);
    cp.display();
  }

  popMatrix();

  minimap.drawCarsMap(-100, -100, isNight, car1, carsPolice);
  gui.draw();
}

void keyPressed() {
  if(key == 'n' || key == 'N') {
    isNight = !isNight;
    environment.setNightMode(isNight);
  } else if(key == 'q' || key == 'Q') {
    firstPerson = !firstPerson;
  } else if(key == 'e' || key == 'E') {
    car1.toggleLights();
  }
  setControl(keyCode, true);
}

void keyReleased() {
  setControl(keyCode, false);
}


void setControl(int code, boolean state) {
  if(code == LEFT || code == 'a' || code == 'A')  car1.isLeft = state;
  if(code == RIGHT || code == 'd' || code == 'D') car1.isRight = state;
  if(code == UP || code == 'w' || code == 'W')   car1.isUp = state;
  if(code == DOWN || code == 's' || code == 'S') car1.isDown = state;
  if(code == CONTROL) car1.isBoost = state;
  if(code == 32) car1.isBreak = state;
  if(code == 'f' || code == 'F') car1.isHonk = state;
}

void mouseMoved() {
  if(firstPerson) {
    camera.look();
  }
}