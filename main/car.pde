class Car {
  PVector pos;
  float oldY;
  float angle;
  float speed;
  float vy;
  float g = 0.125;
  PShape model;

  boolean isLeft, isRight, isUp, isDown;

  Car(float x, float z, float speed, String modelPath) {
    this.pos = new PVector(x, 0, z);
    this.angle = 0;
    this.speed = speed;
    this.oldY = 0;
    this.vy = 0;
    this.model = loadShape(modelPath);
  }

  void update() {
    if(isUp) speed = 2.0;
    else if(isDown) speed = -1.0;
    else speed = 0;

    if(isLeft) angle -= 0.05;
    if(isRight) angle += 0.05;

    pos.x += speed * cos(angle);
    pos.z += speed * sin(angle);
    oldY = pos.y;


    boolean onCircuit = isOnCircuit(pos.x, pos.y, pos.z);
    println(pos);
    // println(onCircuit);
    if(onCircuit) { pos.y = oldY; vy = 0; }
    else { vy += g; pos.y += vy; }
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