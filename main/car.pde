class Car extends Vehicle {
  float FWD_SPEED = 5.8;
  float BWD_SPEED = -2.5;
  float STD_YAW = 0.04;

  boolean isLeft, isRight, isUp, isDown, isSpace; // movement

  Car(PApplet parent, float x, float z, float speed, String modelPath) {
    super.pos = new PVector(x, 0, z);
    super.yaw = 0;
    super.speed = speed;
    super.oldY = 0;
    super.vy = 0;
    super.model = loadShape(modelPath);
    super.file = new SoundFile(parent, "..\\resources\\car_horn.mp3");
  }

  void update(Circuit c, Police police) { //on peut supprimer police
    // controls
    if(isUp) { speed = FWD_SPEED; }
    else if(isDown) { speed = BWD_SPEED; }
    else speed *= 0.9;

    if(isLeft) {        yaw -= STD_YAW;    roll = -0.15 * (speed / 6.0); }
    else if(isRight) {  yaw += STD_YAW;    roll = 0.15 * (speed / 6.0); }
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