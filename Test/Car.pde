class Car {
  PVector pos;
  float oldY;
  float angle;
  float speed;
  float vy;
  float g = 0.125;
  PShape model;

  Car(float x, float y, float z, float speed, String modelPath) {
    this.pos = new PVector(x, y, z);
    this.angle = 0;
    this.speed = speed;
    this.vy = 0;
    this.model = loadShape(modelPath);
  }

  void update() {
    println(pos);
    oldY = pos.y;

    boolean onCircuit = isOnCircuit(pos.x, pos.y, pos.z);
    println(onCircuit);
    if(onCircuit) { pos.y = oldY; vy = 0; } 
    else { vy += g; pos.y += vy; }


    // boolean onCircuit = isOnCircuit(pos.x, pos.y, pos.z);
    // println(onCircuit);
    // if(onCircuit) { speed = 2; } 
    // else { speed = 0.5; }
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