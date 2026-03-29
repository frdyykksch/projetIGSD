class Car {
  PVector pos;
  float angle;
  float speed;
  float y;
  float vy;
  float g = 0.25;
  PShape model;

  Car(float x, float z, float speed, String modelPath) {
    this.pos = new PVector(x, 0, z);
    this.angle = 0;
    this.speed = speed;
    this.y = 0;
    this.vy = 0;
    this.model = loadShape(modelPath);
  }

  void update() {
    pos.x += speed * cos(angle);
    pos.z += speed * sin(angle);

    if(keyPressed) {
      switch(keyCode) {
        case LEFT: angle -= 0.05; break;
        case RIGHT: angle += 0.05; break;
        case UP: speed = 2.0; break; 
        case DOWN: speed = -1.0; break;
      }
    } else { speed = 0; }

    boolean onCircuit = isOnCircuit(pos.x, pos.z);
    if(onCircuit && y <= 0.5) { y = 0; vy = 0; } 
    else { vy += g; y += vy; }
    if(y < 0) { y = 0; vy = 0; }
    pos.y = y;
  }

  void display() {
    pushMatrix();
    
    translate(pos.x, pos.y, pos.z);
    rotateX(PI);
    rotateY(PI);
    rotateY(angle);

    scale(10);
    shape(model);
    
    popMatrix();
  }
}