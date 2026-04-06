class Vehicle {
    PVector pos;
    float oldY; // for collison
    float angle; // yaw
    float speed;
  
    float roll = 0;
    float pitch = 0;
  
    float vy; // gravity, collsision
    float g = 0.125;
  
    PShape model;
    SoundFile file;
  
    boolean isLeft, isRight, isUp, isDown, isSpace; // movement
    boolean lightOn = false;
    boolean soundPlayed = false;
}