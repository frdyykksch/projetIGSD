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
int startTime;

PShader fog;

void setup() {
  size(800, 800, P3D);
  noStroke();

  // controltips
  controlTip = loadImage("..\\resources\\controlTip.jpg");
  startTime = millis();

  // fogshader
  fog = loadShader("..\\resources\\shaders\\fogShader.glsl");

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

  car1 = new Car(this, startPos.x, startPos.y, startPos.z, startYaw, "..\\resources\\mainCar\\insideCar.obj");
  vehicles.add(car1);
  
  Police car2 = new Police(this, endPos.x, endPos.y, endPos.z, startYaw, "..\\resources\\PoliceCar.obj");
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
  if(millis() - startTime < 3000) {
    image(controlTip, 0, 0, width, height);
    return;
  }
  
  background(0);
  
  pushMatrix();
  translate(width / 2, height / 2, 0);
  camera.update();
  
  environment.drawSkybox(8000);
  environment.updateLighting(isNight);
  
  circuitF1.lightCircuit(isNight);
  circuitF1.display();
  
  for(Vehicle v : vehicles) {
    v.backLights();
    v.frontLights();
    v.update(circuitF1);
    v.checkAllVehicleCollisions(vehicles);
    v.fenceCollision(circuitF1.getFenceBoundaries());
    // v.checkBannerCollision(startPos);
    v.display();
  }
  
  
  startBanner.drawBanner();
  popMatrix();
  
  minimap.drawCarsMap(-100, -100, isNight, car1, vehicles);
  gui.drawGUI();

  // ca c'est le gpt qui m'a fait/expliqué mais je comprends ducoup c'est pas mal
  fog.set("u_time", millis() / 1000.0);
  fog.set("u_resolution", (float)width, (float)height);
  fog.set("u_nightMode", isNight ? 0.5 : 0.0);

filter(fog);
}

// toggle
void keyPressed() {
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