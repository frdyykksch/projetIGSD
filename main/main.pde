import processing.sound.*;

Environment environment;
Circuit circuitF1;
ArrayList<Car> cars;
ArrayList<CarP> carsPolice;
Car car1;
CarP car2;

boolean isNight = true;
PVector startPos;

float cameraHeight = 60;
float cameraDistance = 100;
float cameraPitch = 0;
float targetPitch = 0;

PGraphics minimapBuffer;

void setup() {
  size(800, 800, P3D);
  noStroke();

  environment = new Environment(isNight);
  circuitF1 = new Circuit();

  startPos = new PVector(-600, 0, 0);
  cars = new ArrayList<Car>();
  carsPolice = new ArrayList<CarP>();
  car1 = new Car(this, startPos.x, startPos.y, startPos.z, "..\\resources\\Car2.obj");
  cars.add(car1);
  car1.angle = circuitF1.getSpawnAngle();

  car2 = new CarP(this, startPos.x, startPos.y, startPos.z, "..\\resources\\PoliceCar.obj");
  carsPolice.add(car2);
  car2.angle = circuitF1.getSpawnAngle();

  minimapBuffer = createGraphics(150, 150);
}

void draw() {
  background(0);
  pushMatrix();
  translate(width / 2, height / 2, 0);
  setupCamera(car1);
  environment.drawSkybox(4000);
  environment.updateLighting(isNight);

  for (Car c : cars) {
    c.backLights();
    c.update(circuitF1, car2);
    c.display();
  }

  for (CarP cp : carsPolice) {
    cp.backLightsP();
    cp.updateP(circuitF1, car1);
    cp.displayP();
  }

  environment.drawSkybox(4000);
  circuitF1.display();
  popMatrix();

  // Draw minimap (top-left corner)
  drawMinimap(circuitF1, 300, -100, -100);
}

void drawMinimap(Circuit c, float size, float x, float y) {
  ArrayList<PVector> points = c.samplePoints;

  // map/circuit boundaries
  float minX = points.get(0).x; float maxX = points.get(0).x; 
  float minZ = points.get(0).z; float maxZ = points.get(0).z;
  for(PVector p : points) {
    minX = min(minX, p.x); maxX = max(maxX, p.x);
    minZ = min(minZ, p.z); maxZ = max(maxZ, p.z);
  }

  float scale = size / max(maxX - minX, maxZ - minZ);

  hint(DISABLE_DEPTH_TEST);

        // fond
        fill(0, 0, 0, 100);
        noStroke();
        rect(x, y, size, size-80);
        
        
        // cirucit
        stroke(255);
        strokeWeight(2);
        noFill();
        beginShape();
        for (PVector p : points)
        vertex(x + (p.x - minX) * scale, y + (p.z - minZ) * scale);
        endShape(CLOSE);
        
        // car
        fill(255, 0, 0);
        strokeWeight(2);
        pushMatrix();
        translate(x + (car1.pos.x - minX) * scale, y + (car1.pos.z - minZ) * scale);
        rotate(car1.angle);
        triangle(-10, -6, -10, 6, 10, 0);
        popMatrix();

        // la police 
        if (isNight){
        fill(255, 255, 255);
        }else{
        fill(0, 0, 255);
        }
        strokeWeight(2);
        pushMatrix();
        translate(x + (car2.pos.x - minX) * scale, y + (car2.pos.z - minZ) * scale);
        rotate(car2.angle);
        triangle(-10, -6, -10, 6, 10, 0);
        popMatrix();


  hint(ENABLE_DEPTH_TEST);
}

void setupCamera(Car targetCar) {
  targetPitch = targetCar.isUp ? -0.2 : 0.0;
  cameraPitch = lerp(cameraPitch, targetPitch, 0.06);

  float targetHeight = targetCar.isUp ? 40 : 60;
  float targetDistance = targetCar.isUp ? 80 : 100;

  cameraHeight = lerp(cameraHeight, targetHeight, 0.06);
  cameraDistance = lerp(cameraDistance, targetDistance, 0.06);

  float camX = targetCar.pos.x - cos(targetCar.angle) * cameraDistance;
  float camY = targetCar.pos.y - cameraHeight;
  float camZ = targetCar.pos.z - sin(targetCar.angle) * cameraDistance;

  float lookAheadDist = 50;
  float lookX = targetCar.pos.x + cos(targetCar.angle) * lookAheadDist;
  float lookY = targetCar.pos.y + cameraPitch * 200;
  float lookZ = targetCar.pos.z + sin(targetCar.angle) * lookAheadDist;

  camera(camX, camY, camZ, lookX, lookY, lookZ, 0, 1, 0);
  perspective(PI / 2.5, float(width) / float(height), 1, 10000);
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    isNight = !isNight;
    environment.setNightMode(isNight);
  }
  setControl(keyCode, true);
  if (key == 'e' || key == 'E') {
    car1.toggleLights();
  }
}

void keyReleased() {
  setControl(keyCode, false);
}


void setControl(int code, boolean state) {
  if (code == LEFT || code == 'a' || code == 'A')  car1.isLeft = state;
  if (code == RIGHT || code == 'd' || code == 'D') car1.isRight = state;
  if (code == UP || code == 'w' || code == 'W')   car1.isUp = state;
  if (code == DOWN || code == 's' || code == 'S') car1.isDown = state;
  if (code == 32) car1.isSpace = state;
} 