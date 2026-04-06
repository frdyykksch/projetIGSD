class Camera {
  Car targetCar;
  float cameraHeight = 60;
  float cameraDistance = 100;
  float cameraPitch = 0;
  float targetPitch = 0;

  Camera(Car targetCar) {
    this.targetCar = targetCar;
  }

  void update() {
    targetPitch = targetCar.isUp ? -0.2 : 0.0;
    cameraPitch = lerp(cameraPitch, targetPitch, 0.06);

    float targetHeight = targetCar.isUp ? 40 : 60;
    float targetDistance = targetCar.isUp ? 80 : 100;

    cameraHeight = lerp(cameraHeight, targetHeight, 0.06);
    cameraDistance = lerp(cameraDistance, targetDistance, 0.06);

    float camX = targetCar.pos.x - cos(targetCar.yaw) * cameraDistance;
    float camY = targetCar.pos.y - cameraHeight;
    float camZ = targetCar.pos.z - sin(targetCar.yaw) * cameraDistance;

    if (firstPerson) {
      float lookAheadDist = 100;
      camX = targetCar.pos.x- 1 * cos(targetCar.yaw);
      camY = targetCar.pos.y - 11;
      camZ = targetCar.pos.z;
      float lookX = targetCar.pos.x + cos(targetCar.yaw) * lookAheadDist;
      float lookY = camY + cameraPitch * 30;
      float lookZ = targetCar.pos.z + sin(targetCar.yaw) * lookAheadDist;
      camera(camX, camY, camZ, lookX, lookY, lookZ, 0, 1, 0);
    } else {
      float lookAheadDist = 50;
      float lookX = targetCar.pos.x + cos(targetCar.yaw) * lookAheadDist;
      float lookY = targetCar.pos.y + cameraPitch * 200;
      float lookZ = targetCar.pos.z + sin(targetCar.yaw) * lookAheadDist;
      camera(camX, camY, camZ, lookX, lookY, lookZ, 0, 1, 0);
    }
    perspective(PI / 2.5, float(width) / float(height), 1, 10000);
  }

  void look() {
    float centerY = height / 2.0;
    cameraPitch = (pmouseY - centerY) * 0.001; // Scale to reasonable pitch values
    // Clamp pitch to prevent camera flipping
    cameraPitch = constrain(cameraPitch, -PI/4, PI/4);
  }
}

