class Camera {
  PVector pos;
  PVector vel;
  float yaw;    // left/right look (mouse X)
  float pitch;  // up/down look (mouse Y)

  float speed     = 5.0;
  float friction  = 0.85;
  float mouseSens = 0.003;

  boolean wPressed, aPressed, sPressed, dPressed;
  boolean[] keys = new boolean[256];
  int prevMouseX, prevMouseY;
  boolean firstMouse = true;

  Camera(float x, float y, float z) {
    pos   = new PVector(x, y, z);
    vel   = new PVector(0, 0, 0);
    yaw   = 0;
    pitch = 0;
  }

  void update() {
    // Forward direction (flat, ignores pitch for movement)
    PVector forward = new PVector(cos(yaw), sin(yaw), 0);
    PVector right   = new PVector(-sin(yaw), cos(yaw), 0);

    if (keys['w'] || keys['W']) vel.add(PVector.mult(forward, speed));
    if (keys['s'] || keys['S']) vel.add(PVector.mult(forward, -speed));
    if (keys['a'] || keys['A']) vel.add(PVector.mult(right, -speed));
    if (keys['d'] || keys['D']) vel.add(PVector.mult(right, speed));

    vel.mult(friction);
    pos.add(vel);

    pitch = constrain(pitch, -PI/2 + 0.01, PI/2 - 0.01);
  }

  void applyToScene() {
    // Look direction from yaw + pitch
    PVector look = new PVector(
      cos(pitch) * cos(yaw),
      cos(pitch) * sin(yaw),
      sin(pitch)
      );
    PVector target = PVector.add(pos, look);
    camera(pos.x, pos.y, pos.z,
      target.x, target.y, target.z,
      0, 0, -1);  // Z-up
  }

  void mouseMoved() {
    if (firstMouse) {
      prevMouseX = mouseX;
      prevMouseY = mouseY;
      firstMouse = false;
      return;
    }
    int dx = mouseX - prevMouseX;
    int dy = mouseY - prevMouseY;
    yaw   += dx * mouseSens;
    pitch -= dy * mouseSens;   // subtract: mouse up = look up
    pitch  = constrain(pitch, -PI/2 + 0.01, PI/2 - 0.01);
    prevMouseX = mouseX;
    prevMouseY = mouseY;
  }

  void keyPressed(char k) {
    if (k < 256) keys[k] = true;
  }
  void keyReleased(char k) {
    if (k < 256) keys[k] = false;
  }
}
