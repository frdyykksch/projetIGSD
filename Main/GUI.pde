class GUI {
  /*
   * ATTRIBUTES
   */
  Car car;
  PGraphics guiBuffer;
  float size = 150;
  float mapX, mapY;

  /*
   * CONSTRUCTORS
   */
  GUI(Car car) {
    this.car = car;
    guiBuffer = createGraphics(150, 150);
  }

  /*
   * METHODS
   */
  void draw() {
    drawGUI();
  }

  void drawGUI() {
    mapX = width + 100 - size;
    mapY = -100;

    float maxSpeed = car.boostSpeed;
    float speedPercent = constrain(car.speed / maxSpeed, 0.0, 1.0);

    guiBuffer.beginDraw();
    guiBuffer.hint(DISABLE_DEPTH_TEST);
    guiBuffer.background(0, 0, 0, 100);

    guiBuffer.fill(255);
    guiBuffer.textAlign(guiBuffer.LEFT, guiBuffer.TOP);
    guiBuffer.textSize(16);

    guiBuffer.text("Speed: " + nf(speedPercent*100, 1, 1), 10, 10);

    float barWidth = 130;
    float barHeight = 16;
    float bx = 10;
    float by = 35;

    guiBuffer.fill(50);
    guiBuffer.rect(bx, by, barWidth, barHeight);

    float fillWidth = map(car.boostCooldown, 0.0, 20.0, 0.0, barWidth);
    if (car.boostCooldown > 0.5) {
      guiBuffer.fill(0, 200, 255);
    } else {
      guiBuffer.fill(100, 100, 100);
    }
    guiBuffer.rect(bx, by, fillWidth, barHeight);

    guiBuffer.fill(255);
    guiBuffer.text("Boost: " + nf(car.boostCooldown, 1, 1) + "s", bx, by + barHeight + 5);

    guiBuffer.hint(ENABLE_DEPTH_TEST);
    guiBuffer.endDraw();

    hint(DISABLE_DEPTH_TEST);
    image(guiBuffer, mapX, mapY);
    hint(ENABLE_DEPTH_TEST);
  }
}
