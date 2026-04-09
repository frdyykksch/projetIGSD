class GUI {
  Car car;
  PGraphics guiGraphic;
  float size = 150;
  float mapX, mapY;
  int startTime = 0;
  boolean farAway;
  int lapStartTime = 0;
  int lastLapTime = 0;
  float startThreshold = 10000;

  GUI(Car car) {
    this.car = car;
    guiGraphic = createGraphics(350, 200);
    lapStartTime = millis();
  }

  void drawGUI() {
    startTime = millis();
    mapX = width - 200;
    mapY = -100;

    PVector spawnPoint = new PVector(-500, 100, -1000); 
    float distToStart = dist(car.pos.x, car.pos.z, spawnPoint.x, spawnPoint.z);
    
    if(distToStart > startThreshold && !farAway) {
      farAway = true;
    }
    
    if(farAway && distToStart < startThreshold) {
      lastLapTime = millis() - lapStartTime;
      lapStartTime = millis(); 
      farAway = false; 
    }

    int currentLapTime = millis() - lapStartTime;

    float maxSpeed = car.boostSpeed;
    float speedPercent = constrain(car.speed / maxSpeed, 0.0, 1.0);

    guiGraphic.beginDraw();
    guiGraphic.hint(DISABLE_DEPTH_TEST);
    guiGraphic.background(0, 0, 0, 100);

    guiGraphic.fill(255, 255, 255);
    guiGraphic.textAlign(guiGraphic.LEFT, guiGraphic.TOP);
    guiGraphic.textSize(24);

    guiGraphic.text("Speed: " + nf(speedPercent*100, 1, 1), 10, 10);

    float barWidth = 160;
    float barHeight = 20;
    float bx = 10;
    float by = 40;

    guiGraphic.fill(50);
    guiGraphic.rect(bx, by, barWidth, barHeight);

    float fillWidth = map(car.boostCooldown, 0.0, 20.0, 0.0, barWidth);
    if(car.boostCooldown > 0.5) {
      guiGraphic.fill(0, 200, 255);
    } else {
      guiGraphic.fill(100, 100, 100);
    }
    guiGraphic.rect(bx, by, fillWidth, barHeight);

    guiGraphic.fill(255, 255, 255);
    guiGraphic.text("Boost: " + nf(car.boostCooldown, 1, 1) + "s", bx, by + barHeight + 8);

    guiGraphic.fill(255, 255, 255);
    guiGraphic.textSize(22);
    String lapTimeStr = formatTime(currentLapTime);
    guiGraphic.text("Lap: " + lapTimeStr, 10, 100);
    
    if(lastLapTime > 0) {
      String lastLapStr = formatTime(lastLapTime);
      guiGraphic.text("Last: " + lastLapStr, 10, 130);
    }

    guiGraphic.hint(ENABLE_DEPTH_TEST);
    guiGraphic.endDraw();

    hint(DISABLE_DEPTH_TEST);
    image(guiGraphic, mapX, mapY);
    hint(ENABLE_DEPTH_TEST);
  }

  String formatTime(int milliseconds) {
    int totalSeconds = milliseconds / 1000;
    int minutes = totalSeconds / 60;
    int seconds = totalSeconds % 60;
    int ms = milliseconds % 1000;
    
    return nf(minutes, 2) + ":" + nf(seconds, 2) + ":" + nf(ms, 3);
  }
}
