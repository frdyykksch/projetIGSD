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
        this.speed = 10;
        this.oldY = y;
        this.vy = 0;
        this.model = loadShape(modelPath);
    }
    void updateP(Circuit c, Car player) {

        if (targetIndex >= c.samplePoints.size()) targetIndex = 0;
        PVector target = c.samplePoints.get(targetIndex);
        PVector dir = PVector.sub(target, pos);
        float distSquared = dir.x * dir.x + dir.z * dir.z; // avoid expensive mag() calculation

        if (distSquared < 3600) { // 60 squared
            targetIndex = (targetIndex + 1) % c.samplePoints.size();
        } else {
            dir.normalize();
            angle = atan2(dir.z, dir.x);
            pos.x += (speed) * cos(angle);
            pos.z += (speed) * sin(angle);
        }
        
        // Get proper road Y position
        float roadY = c.getRoadY(pos.x, pos.z);
        
        // pitch - reduced lookAhead for better performance
        float lookAhead = 10;
        float nextX = pos.x + cos(angle) * lookAhead;
        float nextZ = pos.z + sin(angle) * lookAhead;
        float nextRoadY = c.getRoadY(nextX, nextZ);
        float targetPitch = atan2(nextRoadY - roadY, lookAhead);
        pitch = lerp(pitch, targetPitch, 0.15);
        
        // gravity and collision
        oldY = pos.y;
        if(c.isCollision(pos.x, pos.y, pos.z)) {
            pos.y = roadY;
            vy = 0;
        } else { 
            vy += g; 
            pos.y += vy; 
        }

        if(pos.y > 200) { 
            pos.set(startPos); 
            vy = 0;
            oldY = 0;
            angle = 0;
            targetIndex = 0;
        } 

        // car collision
        PVector diff = PVector.sub(pos, player.pos);
        float collDistSquared = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;
        int maxDist = 35; 
        if (collDistSquared < maxDist * maxDist) {
            diff.normalize();
            pos.add(PVector.mult(diff, maxDist - sqrt(collDistSquared)));
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