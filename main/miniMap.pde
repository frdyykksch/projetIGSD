
class Minimap {
  /*
   * ATTRIBUTES
   */
  PGraphics minimapBuffer;
  Circuit c;
  ArrayList<PVector> points;
  float minX, maxX, minZ, maxZ, scale;
  float mapSize = 150;
  float mapX, mapY;

	/*
   * CONSTRUCTORS
   */
  Minimap(Circuit c) {
    this.c = c;
    this.points = c.samplePoints;
    minimapBuffer = createGraphics(150, 150);
    calculateBounds();
  }

	/*
   * METHODS
   */
  void calculateBounds() {
    minX = points.get(0).x;
    maxX = points.get(0).x;
    minZ = points.get(0).z;
    maxZ = points.get(0).z;

    for (PVector p : points) {
      minX = min(minX, p.x);
      maxX = max(maxX, p.x);
      minZ = min(minZ, p.z);
      maxZ = max(maxZ, p.z);
    }

    scale = mapSize / max(maxX - minX, maxZ - minZ);
  }

  void drawCircuitMap(float size, float x, float y) {
    mapSize = size;
    mapX = x;
    mapY = y;

    minimapBuffer.beginDraw();
    minimapBuffer.hint(DISABLE_DEPTH_TEST);
    minimapBuffer.background(0, 0, 0, 100);

    float centerX = (maxX + minX) * 0.5;
    float centerZ = (maxZ + minZ) * 0.5;

    minimapBuffer.translate(minimapBuffer.width / 2, minimapBuffer.height / 2);
    minimapBuffer.scale(scale);

    minimapBuffer.stroke(255, 255, 255);
    minimapBuffer.strokeWeight(3);
    minimapBuffer.noFill();
    minimapBuffer.beginShape();
    for (PVector p : points) {
      float px = (p.x - centerX);
      float pz = (p.z - centerZ);
      minimapBuffer.vertex(px, pz);
    }
    minimapBuffer.endShape(CLOSE);
    minimapBuffer.hint(ENABLE_DEPTH_TEST);
    minimapBuffer.endDraw();
  }

  void drawCarsMap(float x, float y, boolean isNight, Car car1, ArrayList<Police> carsPolice) {
    hint(DISABLE_DEPTH_TEST);

    image(minimapBuffer, x, y);

    fill(255, 0, 0);
    strokeWeight(2);
    pushMatrix();
    translate(x + (car1.pos.x - minX) * scale, y + (car1.pos.z - minZ) * scale);
    rotate(car1.yaw);
    triangle(-10, -6, -10, 6, 10, 0);
    popMatrix();

    for (Police cp : carsPolice) {
      if (isNight) {
        fill(255, 255, 255);
      } else {
        fill(0, 0, 255);
      }
      strokeWeight(2);
      pushMatrix();
      translate(x + (cp.pos.x - minX) * scale, y + (cp.pos.z - minZ) * scale);
      rotate(cp.yaw);
      triangle(-10, -6, -10, 6, 10, 0);
      popMatrix();
    }

    hint(ENABLE_DEPTH_TEST);
  }
}
