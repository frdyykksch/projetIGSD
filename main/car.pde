class Car {
  PVector pos;
  float oldY; // for collison
  float angle;
  float speed;

  float tilt = 0;

  float vy; // gravity, collsision
  float g = 0.125;

  PShape model;

  boolean isLeft, isRight, isUp, isDown; // movement

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
    if(isUp)        speed = 5.8;
    else if(isDown) speed = -2.5;
    else speed *= 0.9;

    if(isLeft) {        angle -= 0.06;    tilt = -0.15 * (speed / 6.0); }
    else if(isRight) {  angle += 0.06;    tilt = 0.15 * (speed / 6.0); }
    else { tilt = lerp(tilt, 0, 0.1); }

    // movement
    pos.x += speed * cos(angle);
    pos.z += speed * sin(angle);
    oldY = pos.y;

    // collision
    boolean collision = c.isCollision(pos.x, pos.y, pos.z);
    println(pos);
    if(collision) { pos.y = oldY; vy = 0; }
    else { vy += g; pos.y += vy; }

    if(pos.y > 100) { pos.set(startPos); vy = 0; oldY = 0; angle = c.getSpawnAngle(); } // reset
  }

  void display() {
    pushMatrix();
    
    translate(pos.x, pos.y, pos.z);
    rotateX(PI);
    rotateY(PI);
    rotateY(angle);
    rotateX(tilt);

    scale(10);
    shape(model);
    
    popMatrix();
  }

  void backLights() {
    if (!isNight) return;

    // PRIMARY SOLUTION: Position pointLight directly behind car using angle
    float lightDistance = 25; // Distance behind the car
    float backLightX = pos.x - lightDistance * cos(angle);
    float backLightZ = pos.z - lightDistance * sin(angle);
    float backLightY = pos.y; // Slightly above car for better illumination
    
    //pointLight(255, 0, 0, backLightX, backLightY-2, backLightZ);
    pointLight(255, 0, 0, backLightX, backLightY-10, backLightZ);
    pointLight(100, 100, 100, backLightX, backLightY-2, backLightZ);
  }
}