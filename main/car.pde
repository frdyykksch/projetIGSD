class Car {
  PVector pos;
  float angle;
  float speed;
  PShape model;

  Car(float x, float z, float speed, String modelPath) {
    this.pos = new PVector(x, 0, z);
    this.angle = 0;
    this.speed = speed;
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
    } else {
      speed = 0;
    }
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