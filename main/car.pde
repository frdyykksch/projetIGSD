class Car extends Vehicle {
  /*
   * ATTRIBUTES
   */
  float fwdSpeed = 5.8;
  float bwdSpeed = -2.5;
  float stdYaw = 0.03;

  boolean isLeft, isRight, isUp, isDown, isHonk, isBoost, isBreak, isReverseCam;
  boolean canBoost;

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
  @Override
  void update(Circuit c) {
    if (isBoost && speed > 0) {
      boostCooldown -= 0.1;
    } else {
      boostCooldown += 0.08;
    }
    boostCooldown = constrain(boostCooldown, 0.0, 20.0);

    canBoost = boostCooldown > 0.5;
    if (isUp) {
      speed = (isBoost && canBoost) ? boostSpeed : fwdSpeed;
    } else if (isDown) {
      speed = (isBoost && canBoost) ? bwdSpeed * 1.5 : bwdSpeed;
    } else {
      speed *= 0.96;
    }

    if (isBreak) speed *= 0.7;

    if (isLeft) {
      yaw -= stdYaw;
      roll = -0.15 * (speed / 6.0);
    } else if (isRight) {
      yaw += stdYaw;
      roll = 0.15 * (speed / 6.0);
    } else {
      roll = lerp(roll, 0, 0.1);
    }

    super.update(c);

    float thresh = 0.1;
    if (-pitch > thresh) {
      if (isDown) {
      } else if (isUp) {
        if (isBoost && canBoost) {
          speed = boostSpeed * 0.6;
        } else {
          speed = fwdSpeed * 0.9;
        }
      } else {
        speed = min(speed, 1.0);
      }
    }

    if (isHonk && !soundPlayed) {
      file.play();
      soundPlayed = true;
    } else if (!isHonk) {
      soundPlayed = false;
    }
  }
}