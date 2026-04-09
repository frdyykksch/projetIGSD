class Vehicle {
  PVector pos;
  float oldY;
  float speed;
  float boostSpeed = 13.0;
  float boostCooldown = 20.0;
  float fenceCollisionCooldown;

  float yaw = 0;
  float roll = 0;
  float pitch = 0;

  float vy;
  float g = 0.125;

  PShape model;
  SoundFile file;

  boolean lightOn = false;
  boolean soundPlayed = false;
  boolean isBounce = false;
  float bounceTimer = 0;

  Vehicle(PVector p, float y) {
    pos = p;
    yaw = y;
    oldY = 0;
    speed = 0;
    vy = 0;
  }
  void update(Circuit c) {
    pos.x += speed * cos(yaw);
    pos.z += speed * sin(yaw);
    oldY = pos.y;

    float roadY = c.getRoadY(pos.x, pos.y, pos.z);
    
    if(c.isCollision(pos.x, pos.y, pos.z) && vy >= 0) {
      pos.y = roadY;
      vy = 0;
    } else {
      vy += g;
      pos.y += vy;
    }

    float lookAhead = 10;
    float nextX = pos.x + cos(yaw) * lookAhead;
    float nextZ = pos.z + sin(yaw) * lookAhead;
    float nextRoadY = c.getRoadY(nextX, pos.y, nextZ);
    float targetPitch = atan2(nextRoadY - roadY, lookAhead);
    pitch = lerp(pitch, targetPitch, 0.2);

    // on decremente
    fenceCollisionCooldown -= 0.016; // ~60 FPS
    
    fenceCollision(c.getFenceBoundaries());

    if(pos.y > 500) {
      pos.set(c.getSpawnPoint());
      vy = 0;
      oldY = 0;
      yaw = c.getSpawnYaw();
    }
  }

  void display() {
    pushMatrix();

    translate(pos.x, pos.y, pos.z);
    rotateX(PI);
    rotateY(PI);

    rotateY(yaw);
    rotateX(roll);
    rotateZ(pitch);

    if(isBounce) {
      bounce();
    }
    scale(10);
    shape(model);

    popMatrix();
  }

  void backLights() {
    float lightDistance = 25;
    float backLightX = pos.x - lightDistance * cos(yaw);
    float backLightZ = pos.z - lightDistance * sin(yaw);
    float backLightY = pos.y;
    
    if(!isNight) {
      float intensity = 255 * (1.0 / (1.0 + 0.02 * lightDistance)); 
      pointLight(intensity, intensity, intensity, backLightX+20, backLightY-20, backLightZ);
    }
    if(lightOn && isNight) {
      float intensity = 255 * (1.0 / (1.0 + 0.02 * lightDistance));
      pointLight(intensity, 0, 0, backLightX, backLightY-10, backLightZ);
      pointLight(intensity * 0.4, intensity * 0.4, intensity * 0.4, backLightX, backLightY-2, backLightZ);
    }
    if(lightOn && !isNight) {
      float intensity = 255 * (1.0 / (1.0 + 0.02 * lightDistance));
      pointLight(intensity, 0, 0, backLightX-10, backLightY-10, backLightZ);
    }
  }

  void frontLights() {
    if(lightOn) {
      float lightDistance = 25;
      float frontLightX = pos.x + lightDistance * cos(yaw);
      float frontLightZ = pos.z + lightDistance * sin(yaw);
      float frontLightY = pos.y;
      float intensity = 255 * (1.0 / (1.0 + 0.02 * lightDistance)); 
      pointLight(intensity, intensity * 0.8, 0, frontLightX+13, frontLightY-10, frontLightZ);
    }
  }

  void toggleLights() {
    lightOn = !lightOn;
  }

  void carHorn() {
    if(!file.isPlaying()) {
      file.play();
    }
  }

  void checkBannerCollision(PVector bannerPos) {
    float collisionRadius = 40;
    float distance = dist(pos.x, pos.y, pos.z, bannerPos.x, bannerPos.y, bannerPos.z);

    if(distance < collisionRadius) {
      float pushBackDistance = collisionRadius - distance;
      PVector direction = PVector.sub(pos, bannerPos);
      direction.normalize();
      direction.mult(pushBackDistance);
      pos.add(direction);
    }
  }

  void checkVehicleCollision(Vehicle other) {
    PVector diff = PVector.sub(pos, other.pos);
    float collDistSquared = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;
    int maxDist = 30;
    if(collDistSquared < maxDist * maxDist && collDistSquared > 0) {
      diff.normalize();
      float pushStrength = (maxDist - sqrt(collDistSquared)) * 1.8;
      pos.add(PVector.mult(diff, pushStrength));
      other.pos.sub(PVector.mult(diff, pushStrength));
      if(this instanceof Car) {
        ((Car)this).playCollisionSound();
      } else if(this instanceof Police) {
        ((Police)this).playCollisionSound();
      }
      if(other instanceof Car) {
        ((Car)other).playCollisionSound();
      } else if(other instanceof Police) {
        ((Police)other).playCollisionSound();
      }
    }
  }

  void checkAllVehicleCollisions(ArrayList<Vehicle> vehicles) {
    for(Vehicle other : vehicles) {
      if(other != this) {
        checkVehicleCollision(other);
      }
    }
  }

  void fenceCollision(ArrayList<PVector>[] fenceBoundaries) {
    if(fenceBoundaries == null || fenceBoundaries.length < 2) return;
    
    ArrayList<PVector> leftFence = fenceBoundaries[0];
    ArrayList<PVector> rightFence = fenceBoundaries[1];
    float maxDist = 22; 
    PVector closestLeft = null;
    float closestLeftDist = Float.MAX_VALUE;          
    for(PVector p : leftFence) {
      PVector diff = PVector.sub(pos, p);
      float collDist = diff.mag();
      if(collDist < closestLeftDist) {
        closestLeftDist = collDist;
        closestLeft = diff;
      }
    }
    
    PVector closestRight = null;
    float closestRightDist = Float.MAX_VALUE;
    for(PVector p : rightFence) {
      PVector diff = PVector.sub(pos, p);
      float collDist = diff.mag();
      if(collDist < closestRightDist) {
        closestRightDist = collDist;
        closestRight = diff;
      }
    }
  
    if(closestLeftDist < maxDist && closestLeft != null) {
      closestLeft.normalize();
      pos.add(PVector.mult(closestLeft, maxDist - closestLeftDist));
      speed *= 0.9;
      
      if(fenceCollisionCooldown <= 0) {
        if(this instanceof Car) {
          ((Car)this).playCollisionSound();
        } else if(this instanceof Police) {
          ((Police)this).playCollisionSound();
        }
        fenceCollisionCooldown = 0.9;
      }
    }
    
    if(closestRightDist < maxDist && closestRight != null) {
      closestRight.normalize();
      pos.add(PVector.mult(closestRight, maxDist - closestRightDist));
      speed *= 0.9;
      

      if(fenceCollisionCooldown <= 0) {
        if(this instanceof Car) {
          ((Car)this).playCollisionSound();
        } else if(this instanceof Police) {
          ((Police)this).playCollisionSound();
        }
        fenceCollisionCooldown = 0.9; 
      }
    }
  }

  void bounce() {
    bounceTimer += 0.025;
    if(bounceTimer >= 1.0) bounceTimer = 0;
    float t = bounceTimer;

    if(t < 0.25) {
      float s = t / 0.25;
      scale(1, 1 + s * 0.5, 1);
    } else if(t < 0.5) {
      float s = (t - 0.25) / 0.25;
      scale(1, 1.5 - s * 0.5, 1);
    } else if(t < 0.75) {
      float s = (t - 0.5) / 0.25;
      scale(1, 1, 1 + s * 0.3);
    } else {
      float s = (t - 0.75) / 0.25;
      scale(1, 1, 1.3 - s * 0.3);
    }
  }

  void toggleBounce() {
    isBounce = !isBounce; bounceTimer = 0;
  }
}