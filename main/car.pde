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

  void update(Circuit c) {
    // controls
    if(isUp) speed = 2.8;
    else if(isDown) speed = -1.5;
    else speed *= 0.9;

    if(isLeft) angle -= 0.06;
    if(isRight) angle += 0.06;

    // movement
    pos.x += speed * cos(angle);
    pos.z += speed * sin(angle);
    oldY = pos.y;

    // collision
    boolean collision = c.isCollision(pos.x, pos.y, pos.z);
    println(pos);
    if(collision) { pos.y = oldY; vy = 0; }
    else { vy += g; pos.y += vy; }

    if(pos.y > 100) { pos = startPos; }
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