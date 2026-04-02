ArrayList<PVector> pointsCircuit;
float largeurRoute = 60;
PImage roadTile;

void setupCircuit() {
  pointsCircuit = new ArrayList<PVector>();
  pointsCircuit.add(new PVector(-600, 0, 0));
  pointsCircuit.add(new PVector(-450, 0, -240));
  pointsCircuit.add(new PVector(-380, 0, -330));
  pointsCircuit.add(new PVector(-260, 0, -380));
  pointsCircuit.add(new PVector(-100, 0, -200));
  pointsCircuit.add(new PVector(-20, 0, -160));
  pointsCircuit.add(new PVector(120, 0, -190));
  pointsCircuit.add(new PVector(260, 0, -150));
  pointsCircuit.add(new PVector(380, 0, -60));
  pointsCircuit.add(new PVector(420, 0, 50));
  pointsCircuit.add(new PVector(380, 0, 170));
  pointsCircuit.add(new PVector(280, 0, 250));
  pointsCircuit.add(new PVector(140, 0, 320));
  pointsCircuit.add(new PVector(-20, 0, 360));
  pointsCircuit.add(new PVector(-180, 0, 330));
  pointsCircuit.add(new PVector(-340, 0, 260));
  pointsCircuit.add(new PVector(-460, 0, 160));
  pointsCircuit.add(new PVector(-650, 0, 110));

  roadTile = loadImage("..\\resources\\roadTile.jpg");
}

void drawCircuit() {
  noStroke();
  textureMode(IMAGE);
  beginShape(TRIANGLE_STRIP);
  texture(roadTile);

  int n = pointsCircuit.size();
  int resolution = 20; // bezierDetail
  float vTex = 0;

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < resolution; j++) {
      float t = j / (float)resolution;
      
      // Points de contrôle pour Catmull-Rom
      PVector p0 = pointsCircuit.get((i - 1 + n) % n);
      PVector p1 = pointsCircuit.get(i % n);
      PVector p2 = pointsCircuit.get((i + 1) % n);
      PVector p3 = pointsCircuit.get((i + 2) % n);

      PVector center = catmullRomPoint(p0, p1, p2, p3, t);
      PVector ahead = catmullRomPoint(p0, p1, p2, p3, t + 0.01);
      PVector tangent = PVector.sub(ahead, center);
      tangent.normalize();
      PVector lateral = new PVector(-tangent.z, 0, tangent.x).mult(largeurRoute);

      PVector left = PVector.sub(center, lateral);
      PVector right = PVector.add(center, lateral);

      vertex(left.x, left.y, left.z, 0, vTex);
      vertex(right.x, right.y, right.z, roadTile.width, vTex);
      
      vTex += 10; // Simple increment de texture
    }
  }
  endShape(CLOSE);
}

PVector catmullRomPoint(PVector p0, PVector p1, PVector p2, PVector p3, float t) {
  float t2 = t * t;
  float t3 = t2 * t;
  return new PVector(
    0.5 * ((2 * p1.x) + (-p0.x + p2.x) * t + (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 + (-p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3),
    0.5 * ((2 * p1.y) + (-p0.y + p2.y) * t + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 + (-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3),
    0.5 * ((2 * p1.z) + (-p0.z + p2.z) * t + (2 * p0.z - 5 * p1.z + 4 * p2.z - p3.z) * t2 + (-p0.z + 3 * p1.z - 3 * p2.z + p3.z) * t3)
  );
}