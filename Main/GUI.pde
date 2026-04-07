class GUI {
  /*
   * ATTRIBUTES
   */
  Car car;
  PGraphics guiGraphic;
  float size = 150;
  float mapX, mapY;

  /*
   * CONSTRUCTORS
   */
  GUI(Car car) {
    this.car = car;
    guiGraphic = createGraphics(150, 150);
  }

  /*
   * METHODS
   */
  void drawGUI() {
    mapX = width + 100 - size;
    mapY = -100;

    float maxSpeed = car.boostSpeed;
    float speedPercent = constrain(car.speed / maxSpeed, 0.0, 1.0);

    guiGraphic.beginDraw();
    guiGraphic.hint(DISABLE_DEPTH_TEST);
    guiGraphic.background(0, 0, 0, 100);

    guiGraphic.fill(255);
    guiGraphic.textAlign(guiGraphic.LEFT, guiGraphic.TOP);
    guiGraphic.textSize(16);

    guiGraphic.text("Speed: " + nf(speedPercent*100, 1, 1), 10, 10);

    float barWidth = 130;
    float barHeight = 16;
    float bx = 10;
    float by = 35;

    guiGraphic.fill(50);
    guiGraphic.rect(bx, by, barWidth, barHeight);

    float fillWidth = map(car.boostCooldown, 0.0, 20.0, 0.0, barWidth);
    if(car.boostCooldown > 0.5) {
      guiGraphic.fill(0, 200, 255);
    } else {
      guiGraphic.fill(100, 100, 100);
    }
    guiGraphic.rect(bx, by, fillWidth, barHeight);

    guiGraphic.fill(255);
    guiGraphic.text("Boost: " + nf(car.boostCooldown, 1, 1) + "s", bx, by + barHeight + 5);

    guiGraphic.hint(ENABLE_DEPTH_TEST);
    guiGraphic.endDraw();

    hint(DISABLE_DEPTH_TEST);
    image(guiGraphic, mapX, mapY);
    hint(ENABLE_DEPTH_TEST);
  }
}
