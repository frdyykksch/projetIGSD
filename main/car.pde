class Car extends Vehicle {
  float FWD_SPEED = 5.8;
  float BWD_SPEED = -2.5;
  float STD_YAW = 0.03;

  boolean isLeft, isRight, isUp, isDown, isSpace, isBoost; // movement

  Car(PApplet parent, float x, float y, float z, float yaw, String modelPath) {
    super(new PVector(x, y, z), yaw);
    super.model = loadShape(modelPath);
    super.file = new SoundFile(parent, "..\\resources\\car_horn.mp3");
  }

  void update(Circuit c) {
    // boost cooldown: +0.01 when not boosting, -0.1 when boosting
    println("Boost (max 20.0): " + boostCooldown);
    if (isBoost) { boostCooldown -= 0.1; } else { boostCooldown += 0.08; }
    boostCooldown = constrain(boostCooldown, 0.0, 20.0);

    // controls
    boolean canBoost = boostCooldown > 0.5;
    if(isUp) { speed = (isBoost && canBoost) ? boostSpeed : FWD_SPEED; }
    else if(isDown) { speed = (isBoost && canBoost) ? BWD_SPEED * 1.5 : BWD_SPEED; }
    else speed *= 0.9;

    if(isLeft) { yaw -= STD_YAW;    roll = -0.15 * (speed / 6.0); }
    else if(isRight) { yaw += STD_YAW;    roll = 0.15 * (speed / 6.0); }
    else { roll = lerp(roll, 0, 0.1); }

    float roadY = c.getRoadY(pos.x, pos.y, pos.z);
    
    // pitch
    float lookAhead = 10;
    float nextX = pos.x + cos(yaw) * lookAhead;
    float nextZ = pos.z + sin(yaw) * lookAhead;
    float nextRoadY = c.getRoadY(nextX, pos.y, nextZ);
    float targetPitch = atan2(nextRoadY - roadY, lookAhead);
    pitch = lerp(pitch, targetPitch, 0.2);

    // sound
    if (isSpace && !soundPlayed) {
      file.play();
      soundPlayed = true;
    } else if (!isSpace) {
      soundPlayed = false;
    }

    // movement
    pos.x += speed * cos(yaw);
    pos.z += speed * sin(yaw);
    oldY = pos.y;

    if(c.isCollision(pos.x, pos.y, pos.z)) {
      // float roadY = c.getRoadY(pos.x, pos.z);
      pos.y = roadY;
      vy = 0;
    } else { vy += g; pos.y += vy; }

    if(pos.y > 500) { pos.set(startPos); vy = 0; oldY = 0; yaw = c.getSpawnYaw(); } // reset
  }
}