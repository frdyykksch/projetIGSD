class CarP {
  PVector pos;
  float oldY; // for collison
  float angle;
  float speed;


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

        if (targetIndex >= c.samplePoints.size()) targetIndex = 0;
        PVector target = c.samplePoints.get(targetIndex);
        PVector dir = PVector.sub(target, pos);
        float dist = dir.mag();
        float r1 = random(-2, 6); //tester

        if (dist < 20 + r1) {
            targetIndex = (targetIndex + 1) % c.samplePoints.size();
            //pour faire la boucle on fait modulo
        } else {
            dir.normalize();
            // Follow circuit in 3D (x, y, z)
            angle = atan2(dir.z, dir.x);
            pos.x += (speed) * cos(angle);
            pos.y += (speed) * dir.y;
            pos.z += (speed) * sin(angle);
        }
        // gravity and collision
        boolean collision = c.isCollision(pos.x, pos.y, pos.z);
        if(collision) { pos.y = oldY; vy = 0; }
        else { vy += g; pos.y += vy; }

        if(pos.y > 100) { pos.set(startPos); 
        vy = 0;
        oldY = 0;
        angle = 0;
        targetIndex = 0;
        } 

        // car collision
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

    scale(10);
    shape(model);
    
    popMatrix();
  }
}