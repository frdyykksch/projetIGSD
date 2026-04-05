class Car {
  PVector pos;
  float oldY; // for collison
  float angle;
  float speed;


  float tilt = 0;

  float vy; // gravity, collsision
  float g = 0.125;

  PShape model;
  SoundFile file;

  boolean isLeft, isRight, isUp, isDown, isSpace; // movement
  boolean lightOn = false;
  boolean soundPlayed = false;

  Car(PApplet parent, float x, float z, float speed, String modelPath) {
    this.pos = new PVector(x, 0, z);
    this.angle = 0;
    this.speed = speed;
    this.oldY = 0;
    this.vy = 0;
    this.model = loadShape(modelPath);
    this.file = new SoundFile(parent, "..\\resources\\car_horn.mp3");
  }

  void update(Circuit c, CarP police) { //on peut supprimer police
    // controls
    if(isUp)        speed = 5.8;
    else if(isDown) speed = -2.5;
    else speed *= 0.9;

    if(isLeft) {        angle -= 0.06;    tilt = -0.15 * (speed / 6.0); }
    else if(isRight) {  angle += 0.06;    tilt = 0.15 * (speed / 6.0); }
    else { tilt = lerp(tilt, 0, 0.1); }

    // sound
    if (isSpace && !soundPlayed) {
      file.play();
      soundPlayed = true;
    } else if (!isSpace) {
      soundPlayed = false;
    }

    // movement
    pos.x += speed * cos(angle);
    pos.z += speed * sin(angle);
    oldY = pos.y;

    // collision
    boolean collision = c.isCollision(pos.x, pos.y, pos.z);
    println(pos);
    if(collision) { pos.y = oldY; vy = 0; }
    else { vy += g; pos.y += vy; }

    if(pos.y > 100) { pos.set(startPos); vy = 0; oldY = 0; angle = c.getSpawnAngle(); } 

    /**
    PVector diff = PVector.sub(pos, police.pos);
        float collDist = diff.mag();
        int maxDist = 30; 
        if (collDist < maxDist) {
            diff.normalize();
            pos.add(PVector.mult(diff, maxDist - collDist)); // push back
        }// reset

    */
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
    if (!lightOn) return;
    if (!isNight) return;

    float lightDistance = 25; // Distance behind the car
    float backLightX = pos.x - lightDistance * cos(angle);
    float backLightZ = pos.z - lightDistance * sin(angle);
    float backLightY = pos.y; // Slightly above car for better illumination
    pointLight(255, 0, 0, backLightX, backLightY-10, backLightZ);
    pointLight(100, 100, 100, backLightX, backLightY-2, backLightZ);
  }

  void toggleLights() {
    lightOn = !lightOn;
  }
  void carHorn() {
    if (!file.isPlaying()) {
      file.play();
    }
  }
}