import processing.sound.*;

Environment environment;
boolean isNight = false;

Circuit circuitF1;
Minimap minimap;

ArrayList<Vehicle> vehicles;
Car car1;
boolean firstPerson = false;

Camera camera;
GUI gui;

Props startBanner;

PImage controlTip;
boolean gameStarted = false;
int startTime;

void setup() {
  size(800, 800, P3D);
  noStroke();

  controlTip = loadImage("..\\resources\\controlTip.jpg");
  startTime = millis();

  // env
  environment = new Environment(isNight);
  
  // circuit
  circuitF1 = new Circuit();

  PVector startPos = circuitF1.getSpawnPoint();
  PVector endPos = circuitF1.getLastPoint();
  float startYaw = circuitF1.getSpawnYaw();
  circuitF1.setupCircuit();

  // vehicles
  vehicles = new ArrayList<Vehicle>();

  car1 = new Car(this, startPos.x, startPos.y, startPos.z, startYaw, "..\\resources\\mainCar2\\insideCar.obj");
  vehicles.add(car1);
  
  Police car2 = new Police(this, startPos.x, startPos.y, startPos.z, startYaw, "..\\resources\\PoliceCar.obj");
  vehicles.add(car2);
  car2.toggleBounce();
  
  // camera & gui
  camera = new Camera(car1);
  gui = new GUI(car1);

  // banner = new Props(this, startPos.x, startPos.y-1, startPos.z, 20, "../resources/finish/BannerStartEnd.obj");
  startBanner = new Props(this, startPos.x, startPos.y-1, startPos.z, 20, "../resources/startBanner/1startBanner.obj");

  // minimap
  minimap = new Minimap(circuitF1);
  minimap.drawCircuitMap(250, -100, -100);
}

void draw() {
  if(!gameStarted && millis() - startTime < 4000) {
    image(controlTip, 0, 0, width, height);
    return;
  } gameStarted = true;

  background(0);

  pushMatrix();
  translate(width / 2, height / 2, 0);
  camera.update();
  
  environment.drawSkybox(8000);
  environment.updateLighting(isNight);
  
  // Set up vehicle lights before drawing circuit
  for(Vehicle v : vehicles) {
    v.backLights();
    v.frontLights();
  }
  
  circuitF1.lightCircuit(isNight);
  circuitF1.display();

  // Reset collision sounds and update vehicles
  for(Vehicle v : vehicles) {
    if(v instanceof Car) {
      ((Car)v).resetCollisionSound();
    } else if(v instanceof Police) {
      ((Police)v).resetCollisionSound();
    }
    v.update(circuitF1);
    v.checkAllVehicleCollisions(vehicles);
    v.fenceCollision(circuitF1.getFenceBoundaries());
    // v.checkBannerCollision(startPos);
    v.display();
  }

  
  startBanner.drawBanner();
  popMatrix();

  hint(DISABLE_DEPTH_TEST);
  resetShader();
  minimap.drawCarsMap(-100, -100, isNight, car1, vehicles);
  gui.drawGUI();
  hint(ENABLE_DEPTH_TEST);
}

// toggle
void keyPressed() {
  if(!gameStarted) gameStarted = true;
  switch(key) {
    case 'n': case 'N': 
      isNight = !isNight; environment.setNightMode(isNight); break;
    case 'q': case 'Q':
      firstPerson = !firstPerson; break;
    case 'e': case 'E':
      car1.toggleLights(); break;
    case 'b': case 'B':
      car1.toggleBounce();
      car1.toggleMusic();
      break;
  }
  setControl(keyCode, true);
}

void keyReleased() {
  setControl(keyCode, false);
}

// hold
void setControl(int code, boolean state) {
  switch(code) {
    case LEFT: case 'a': case 'A':
      car1.isLeft = state; break;
    case RIGHT: case 'd': case 'D':
      car1.isRight = state; break;
    case UP: case 'w': case 'W':
      car1.isUp = state; break;
    case DOWN: case 's': case 'S':
      car1.isDown = state; break;
    case CONTROL:
      car1.isBoost = state; break;
    case 32: // space
      car1.isBreak = state; break;
    case 'f': case 'F':
      car1.isHonk = state; break;
    case 'r': case 'R':
      car1.isReverseCam = state; break;
    case 'c': case 'C':
      car1.isJump = state; break;
  }
}

void mouseMoved() {
  if(firstPerson) {
    camera.look();
  }
}