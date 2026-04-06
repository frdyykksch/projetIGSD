class CarP {
  PVector pos;
  float oldY; // pour la collision
  float angle;
  float speed;
  float pitch = 0;


  float tilt = 0;

  float vy; // gravity, collsision
  float g = 0.125;

  PShape model;

  //boolean isLeft, isRight, isUp, isDown, isSpace; // movement
  boolean lightOn = false;
  boolean soundPlayed = false;

  int targetIndex = 0;

    CarP(PApplet parent, float x, float y, float z, String modelPath) {
        this.pos = new PVector(x, y, z);
        this.angle = 0;
        this.speed = 3;
        this.oldY = y;
        this.vy = 0;
        this.model = loadShape(modelPath);
    }
    void updateP(Circuit c, Car player) {

        float minDist = Float.MAX_VALUE;
        int closestIndex = 0;
        
        for (int i = 0; i < c.samplePoints.size(); i++) {
            PVector point = c.samplePoints.get(i);
            float dist = PVector.dist(pos, point);
            if (dist < minDist) {
                minDist = dist;
                closestIndex = i;
            }
        }
        int lookAheadPoints = 4;
        targetIndex = (closestIndex + lookAheadPoints) % c.samplePoints.size();
        PVector target = c.samplePoints.get(targetIndex);

        PVector dir = PVector.sub(target, pos);
        float distToTarget = dir.mag();

        if (distToTarget < 50) {
            targetIndex = (targetIndex + 1) % c.samplePoints.size();
            target = c.samplePoints.get(targetIndex);
            dir = PVector.sub(target, pos);
        }
        

        float roadY = c.getRoadY(pos.x, pos.z);
        
        float lookAheadDist = 30;
        float nextX = pos.x + cos(angle) * lookAheadDist;
        float nextZ = pos.z + sin(angle) * lookAheadDist;
        float nextRoadY = c.getRoadY(nextX, nextZ);
        float targetPitch = atan2(nextRoadY - roadY, lookAheadDist);
        pitch = lerp(pitch, targetPitch, 0.2);
        
        // angle
        float targetAngle = atan2(dir.z, dir.x);
        angle = lerp(angle, targetAngle, 0.05);

        pos.x += speed * cos(angle);
        pos.z += speed * sin(angle);
        oldY = pos.y;
        
        if(c.isCollision(pos.x, pos.y, pos.z)) {
            pos.y = roadY; 
            vy = 0;
        } else { 
            vy += g; 
            pos.y += vy; 
        }

        if(pos.y > 100) { 
            pos.set(startPos); 
            vy = 0;
            oldY = 0;
            angle = c.getSpawnAngle(); 
            targetIndex = 0; 
        } 

        PVector diff = PVector.sub(pos, player.pos);
        float collDist = diff.mag();
        int maxDist = 35; 
        if (collDist < maxDist) {
            diff.normalize();
            pos.add(PVector.mult(diff, maxDist - collDist)); // push back
        }
    }
    void backLightsP() {
    if (!isNight) return;

    float lightDistance = 25; // Distance behind the car
    float backLightX = pos.x - lightDistance * cos(angle);
    float backLightZ = pos.z - lightDistance * sin(angle);
    float backLightY = pos.y; // Slightly above car for better illumination
    pointLight(255, 0, 0, backLightX, backLightY-10, backLightZ);
    pointLight(100, 100, 100, backLightX, backLightY-2, backLightZ);
  }
    void displayP() {
    pushMatrix();
    
    translate(pos.x, pos.y, pos.z);
    rotateX(PI);
    rotateY(PI);
    rotateY(angle);
    rotateX(tilt);
    rotateZ(pitch); 

    scale(10);
    shape(model);
    
    popMatrix();
  }
}