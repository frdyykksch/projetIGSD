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

    if(targetCar.isBoost && targetCar.canBoost) {
      targetDistance += 30;
    }

    cameraHeight = lerp(cameraHeight, targetHeight, 0.06);
    cameraDistance = lerp(cameraDistance, targetDistance, 0.04);

    float camX = targetCar.pos.x - cos(targetCar.yaw) * cameraDistance;
    float camY = targetCar.pos.y - cameraHeight;
    float camZ = targetCar.pos.z - sin(targetCar.yaw) * cameraDistance;

    if(targetCar.isReverseCam) {
      float rcamDist = 50;
      float rcamHeight = 20;

      camX = targetCar.pos.x + cos(targetCar.yaw) * rcamDist;
      camY = targetCar.pos.y - rcamHeight;
      camZ = targetCar.pos.z + sin(targetCar.yaw) * rcamDist;

      float lookX = targetCar.pos.x - cos(targetCar.yaw) * 50;
      float lookY = targetCar.pos.y;
      float lookZ = targetCar.pos.z - sin(targetCar.yaw) * 50;

      camera(camX, camY, camZ, lookX, lookY, lookZ, 0, 1, 0);

    // fpv
    } else if(firstPerson) {
      float lookAheadDist = 150;

      camX = targetCar.pos.x - 1.2 * cos(targetCar.yaw);
      camY = targetCar.pos.y - 10;
      camZ = targetCar.pos.z - 1.2 * sin(targetCar.yaw);

      float lookX = targetCar.pos.x + cos(targetCar.yaw) * lookAheadDist;
      float lookY = targetCar.pos.y + 30;
      float lookZ = targetCar.pos.z + sin(targetCar.yaw) * lookAheadDist;

      float upX = 0;
      float upY = cos(targetCar.roll);
      float upZ = sin(targetCar.roll);

      camera(camX, camY, camZ, lookX, lookY, lookZ, upX, upY, upZ);
      
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
    cameraPitch = (pmouseY - centerY) * 0.001;
    cameraPitch = constrain(cameraPitch, -PI/4, PI/4);
  }
}