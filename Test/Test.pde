boolean isNight = false;
ArrayList<Car> cars;
Car car1;
Car car2;

void setup() {
  size(800, 800, P3D);
  noStroke();

  setupCircuit(); // Initialise les points du circuit
  
  cars = new ArrayList<Car>();
  // car1 : contrôlée par le joueur (commence à l'index 0)
  car1 = new Car(0, "..\\resources\\Car2.obj");
  // car2 : IA ou vitesse constante (commence à l'index 5)
  car2 = new Car(5, "..\\resources\\PoliceCar.obj");
  car2.speed = 0.02; // La deuxième voiture avance seule
  
  cars.add(car1);
  cars.add(car2);
  
  setupEnv();
}

void draw() {
  background(0);
  
  // --- VUE 1 : Caméra Suiveuse (Plein écran) ---
  PVector p = car1.getWorldPos(car1.trackPos.x);
  PVector target = car1.getWorldPos(car1.trackPos.x + 0.1);
  
  float dist = 150;
  float h = 60;
  PVector dir = PVector.sub(p, target);
  dir.normalize();
  
  camera(p.x + dir.x*dist, p.y - h, p.z + dir.z*dist, 
         p.x, p.y, p.z, 
         0, 1, 0);
  
  renderScene();

  // --- VUE 2 : Minimap (Haut à gauche) ---
  hint(DISABLE_DEPTH_TEST);
  // On définit une zone de dessin de 200x200
  pushMatrix();
  // Caméra vue du ciel : très haute sur Y, regarde vers le bas
  camera(0, -1500, 0, 0, 0, 0, 0, 0, -1);
  perspective(PI/4.0, 1.0, 10, 5000);
  
  viewport(10, 10, 200, 200); 
  renderScene();
  popMatrix();
  hint(ENABLE_DEPTH_TEST);
  
  // Reset viewport pour le prochain frame
  viewport(0, 0, width, height);
}

void renderScene() {
  updateLighting(isNight);
  drawSkybox(4000);
  drawCircuit();
  for(Car c : cars) {
    c.update();
    c.display();
  }
}

void viewport(int x, int y, int w, int h) {
  resetMatrix();
  float ratio = (float)w / (float)h;
  perspective(PI/3.0, ratio, 1, 10000);
}

void keyPressed() {
  if(key == 'n' || key == 'N') {
    isNight = !isNight;
    cubeNightDay(isNight);
  }
  setControl(keyCode, key, true);
}

void keyReleased() {
  setControl(keyCode, key, false);
}

void setControl(int code, char k, boolean state) {
  if(code == LEFT  || k == 'a' || k == 'A') car1.isLeft  = state;
  if(code == RIGHT || k == 'd' || k == 'D') car1.isRight = state;
  if(code == UP    || k == 'w' || k == 'W') car1.isUp    = state;
  if(code == DOWN  || k == 's' || k == 'S') car1.isDown  = state;
}