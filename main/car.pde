class Car extends Vehicle {
  /*
   * ATTRIBUTES
   */
  float fwdSpeed = 5.8;
  float bwdSpeed = -2.5;
  float stdYaw = 0.03;

  boolean isLeft, isRight, isUp, isDown, isSpace, isBoost;

  /*
   * CONSTRUCTORS
   */
  Car(PApplet parent, float x, float y, float z, float yaw, String modelPath) {
    super(new PVector(x, y, z), yaw);
    super.model = loadShape(modelPath);
    super.file = new SoundFile(parent, "..\\resources\\car_horn.mp3");
  }

  /*
   * METHODS
   */
  void update(Circuit c) {
    if(isBoost && speed > 0) { boostCooldown -= 0.1; } else { boostCooldown += 0.08; }
    boostCooldown = constrain(boostCooldown, 0.0, 20.0);

    boolean canBoost = boostCooldown > 0.5;
    if(isUp) { speed = (isBoost && canBoost) ? boostSpeed : fwdSpeed; }
    else if(isDown) { speed = (isBoost && canBoost) ? bwdSpeed * 1.5 : bwdSpeed; }
    else speed *= 0.9;

    if(isLeft) { yaw -= stdYaw;    roll = -0.15 * (speed / 6.0); }
    else if(isRight) { yaw += stdYaw;    roll = 0.15 * (speed / 6.0); }
    else { roll = lerp(roll, 0, 0.1); }

    float roadY = c.getRoadY(pos.x, pos.y, pos.z);

    float lookAhead = 10;
    float nextX = pos.x + cos(yaw) * lookAhead;
    float nextZ = pos.z + sin(yaw) * lookAhead;
    float nextRoadY = c.getRoadY(nextX, pos.y, nextZ);
    float targetPitch = atan2(nextRoadY - roadY, lookAhead);
    pitch = lerp(pitch, targetPitch, 0.2);

    float thresh = 0.1;
    if(-pitch > thresh) {
      if(isDown) {
      } else if(isUp) {
        if(isBoost && canBoost) {
          speed = boostSpeed * 0.5;
        } else {
          speed = fwdSpeed * 0.7;
        }
      } else {
        speed = min(speed, 1.0);
      }
    }



    if(isSpace && !soundPlayed) {
      file.play();
      soundPlayed = true;
    } else if(!isSpace) {
      soundPlayed = false;
    }

    pos.x += speed * cos(yaw);
    pos.z += speed * sin(yaw);
    oldY = pos.y;

    if(c.isCollision(pos.x, pos.y, pos.z)) {
      pos.y = roadY;
      vy = 0;
    } else { vy += g; pos.y += vy; }

    if(pos.y > 500) { pos.set(startPos); vy = 0; oldY = 0; yaw = c.getSpawnYaw(); }
  }
}