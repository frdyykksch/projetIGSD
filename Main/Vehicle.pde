class Vehicle {
    PVector pos;
    float oldY; // for collison
    float speed;
    float boostSpeed = 13.0;
    float boostCooldown = 20.0; // boost only works when >0.5, gains 0.01 every tick, reduces by 0.1 every tick when using

    float yaw = 0; // yaw
    float roll = 0;
    float pitch = 0;

    float vy; // gravity, collsision
    float g = 0.125;

    PShape model;
    SoundFile file;

    boolean lightOn = false;
    boolean soundPlayed = false;

    Vehicle(PVector p, float y) {
        pos = p;
        yaw = y;
        oldY = 0;
        speed = 0;
        vy = 0;
    }

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
        if (!lightOn) return;
        if (!isNight) return;

        float lightDistance = 25; // Distance behind the car
        float backLightX = pos.x - lightDistance * cos(yaw);
        float backLightZ = pos.z - lightDistance * sin(yaw);
        float backLightY = pos.y; // Slightly above car for better illumination
        pointLight(255, 0, 0, backLightX, backLightY-10, backLightZ);
        pointLight(100, 100, 100, backLightX, backLightY-2, backLightZ);
    }

    void frontLights() {
        // failed
    }

    void toggleLights() {
    lightOn = !lightOn;
    }

    void carHorn() {
        if(!file.isPlaying()) {
            file.play();
        }
    }
}