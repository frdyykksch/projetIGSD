class Vehicle {
  /*
   * ATTRIBUTES
   */
  PVector pos;
  float oldY;
  float speed;
  float boostSpeed = 13.0;
  float boostCooldown = 20.0;

  float yaw = 0;
  float roll = 0;
  float pitch = 0;

  float vy;
  float g = 0.125;

  PShape model;
  SoundFile file;

  boolean lightOn = false;
  boolean soundPlayed = false;

	/*
   * CONSTRUCTORS
   */
  Vehicle(PVector p, float y) {
    pos = p;
    yaw = y;
    oldY = 0;
    speed = 0;
    vy = 0;
  }

	/*
   * METHODS
   */
  void display() {
    pushMatrix();

    translate(pos.x, pos.y, pos.z);
    rotateX(PI);
    rotateY(PI);

    rotateY(yaw);
    rotateX(roll);
    rotateZ(pitch);

    scale(10);
    shape(model);

    popMatrix();
  }

  void backLights() {
    if (!isNight){
        float lightDistance = 25;
        float backLightX = pos.x - lightDistance * cos(yaw);
        float backLightZ = pos.z - lightDistance * sin(yaw);
        float backLightY = pos.y;
        pointLight(255, 255, 255, backLightX+20, backLightY-20, backLightZ);
    }
    if(lightOn && isNight) {
        float lightDistance = 25;
        float backLightX = pos.x - lightDistance * cos(yaw);
        float backLightZ = pos.z - lightDistance * sin(yaw);
        float backLightY = pos.y;
        pointLight(255, 0, 0, backLightX, backLightY-10, backLightZ);
        pointLight(100, 100, 100, backLightX, backLightY-2, backLightZ);
    }
    if(lightOn && !isNight) {
        float lightDistance = 25;
        float backLightX = pos.x - lightDistance * cos(yaw);
        float backLightZ = pos.z - lightDistance * sin(yaw);
        float backLightY = pos.y;
        pointLight(255, 0, 0, backLightX-10, backLightY-10, backLightZ);
        }
  }

  void frontLights() {
    if(lightOn && isNight) {
        float lightDistance = 25;
        float frontLightX = pos.x + lightDistance * cos(yaw);
        float frontLightZ = pos.z + lightDistance * sin(yaw);
        float frontLightY = pos.y;
        pointLight(255, 255, 0, frontLightX+13, frontLightY-10, frontLightZ);
    }
    if(lightOn && !isNight) {
        float lightDistance = 25;
        float frontLightX = pos.x + lightDistance * cos(yaw);
        float frontLightZ = pos.z + lightDistance * sin(yaw);
        float frontLightY = pos.y;
        pointLight(255, 255, 0, frontLightX+13, frontLightY-10, frontLightZ);
        }
  }

  void toggleLights() {
    lightOn = !lightOn;
  }

  void carHorn() {
    if (!file.isPlaying()) {
      file.play();
    }
  }

  void checkBannerCollision(PVector bannerPos) {
    float collisionRadius = 40; // Collision radius for the banner
    float distance = dist(pos.x, pos.y, pos.z, bannerPos.x, bannerPos.y, bannerPos.z);
    
    if (distance < collisionRadius) {
      // Push the vehicle back from the banner
      float pushBackDistance = collisionRadius - distance;
      PVector direction = PVector.sub(pos, bannerPos);
      direction.normalize();
      direction.mult(pushBackDistance);
      pos.add(direction);
    }
  }
}
