class Car extends Vehicle {
  /*
   * ATTRIBUTES
   */
  float fwdSpeed = 5.8;
  float bwdSpeed = -2.5;
  float acceleration = 0.05;
  float stdYaw = 0.03;

  float jumpForce = -5.0;

  boolean isLeft, isRight, isUp, isDown, isHonk, isBoost, isBreak, isReverseCam, isJump, isMusic;
  boolean canBoost;
  
  SoundFile musicFile;
  SoundFile collisionSound;
  boolean collisionSoundPlayed = false;


  /*
   * CONSTRUCTORS
   */
  Car(PApplet parent, float x, float y, float z, float yaw, String modelPath) {
    super(new PVector(x, y, z), yaw);
    super.model = loadShape(modelPath);
    super.file = new SoundFile(parent, "..\\resources\\car_horn.wav");
    musicFile = new SoundFile(parent, "..\\resources\\music.wav");
    collisionSound = new SoundFile(parent, "..\\resources\\car1Bump.wav");
  }

  /*
   * METHODS
   */
  @Override
  void update(Circuit c) {
    boostCooldown += (isBoost && speed > 0) ? -0.1 : 0.08;
    boostCooldown = constrain(boostCooldown, 0.0, 20.0);
    canBoost = boostCooldown > 0.5;

    if(isUp) {
      float targetSpeed = (isBoost && canBoost) ? boostSpeed : fwdSpeed;
      speed = lerp(speed, targetSpeed, acceleration);
    } else if(isDown) {
      speed = (isBoost && canBoost) ? bwdSpeed * 1.5 : bwdSpeed;
    } else {
      speed *= 0.96;
    }

    if(isLeft) {
      yaw -= stdYaw;
      roll = -0.15 * (speed / 6.0);
    } else if(isRight) {
      yaw += stdYaw;
      roll = 0.15 * (speed / 6.0);
    } else {
      roll = lerp(roll, 0, 0.1);
    }
    
    if(isBreak) speed *= 0.67;


    boolean onGround = c.isCollision(pos.x, pos.y, pos.z);
    if(isJump && onGround) {
      vy = jumpForce;
      pos.y -= 2;
    }

    super.update(c);

    float thresh = 0.1;
    if(-pitch > thresh) {
      if(isDown) {
      } else if(isUp) {
        if(isBoost && canBoost) {
          speed = boostSpeed * 0.6;
        } else {
          speed = fwdSpeed * 0.68;
        }
      } else {
        speed = min(speed, 1.0);
      }
    }

    if(isHonk && !soundPlayed) {
      file.play();
      soundPlayed = true;
    } else if(!isHonk) {
      soundPlayed = false;
    }
    
    if (isMusic && !musicFile.isPlaying()) {
      musicFile.loop();
    } else if (!isMusic && musicFile.isPlaying()) {
      musicFile.stop();
    }
  }
  
  void toggleMusic() {
    isMusic = !isMusic;
  }
  
  void playCollisionSound() {
    if(!collisionSoundPlayed && collisionSound != null) {
      collisionSound.play();
      collisionSoundPlayed = true;
    }
  }
  
  void resetCollisionSound() {
    collisionSoundPlayed = false;
  }
}