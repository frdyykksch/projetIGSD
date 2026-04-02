ArrayList<PVector> pointsCircuit;
int segmentsParCourbe = 20;
float largeurRoute = 40;
PImage roadTile;
ArrayList<PVector> samplePoints;

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

  int stepsPerSegment = segmentsParCourbe;
  samplePoints = sampleCircuit(stepsPerSegment);

  beginShape(TRIANGLE_STRIP);
  texture(roadTile);

  float vTex = 0;
  float vScale = roadTile.height / 80.0;
  int m = samplePoints.size();

  pushMatrix();
  for(int i = 0; i < m; i++) {
    pushMatrix();
    PVector pt = samplePoints.get(i);
    PVector nextPt = samplePoints.get((i + 1) % m);

    PVector tangent = PVector.sub(nextPt, pt);
    tangent.normalize();

    PVector n = new PVector(-tangent.z, 0, tangent.x);
    n.normalize();
    n.mult(largeurRoute);

    PVector left = PVector.sub(pt, n);
    PVector right = PVector.add(pt, n);

    float u0 = 0;
    float u1 = roadTile.width;

    vertex(left.x, left.y, left.z, u0, vTex);
    vertex(right.x, right.y, right.z, u1, vTex);

    vTex += PVector.dist(pt, nextPt) * vScale;
    if(vTex > roadTile.height) vTex %= roadTile.height;
    popMatrix();
  } popMatrix();

  endShape(CLOSE);
}

ArrayList<PVector> sampleCircuit(int stepsPerSegment) {
  ArrayList<PVector> sample = new ArrayList<PVector>();
  int n = pointsCircuit.size();

  for(int i = 0; i < n; i++) {
    PVector p0 = pointsCircuit.get((i - 1 + n) % n);
    PVector p1 = pointsCircuit.get(i);
    PVector p2 = pointsCircuit.get((i + 1) % n);
    PVector p3 = pointsCircuit.get((i + 2) % n);

    for (int s = 0; s < stepsPerSegment; s++) {
      float t = s / (float) stepsPerSegment;
      sample.add(catmullRomPoint(p0, p1, p2, p3, t));
    }
  }
  sample.add(sample.get(0).copy());
  return sample;
}

PVector catmullRomPoint(PVector p0, PVector p1, PVector p2, PVector p3, float t) {
  float t2 = t*t;
  float t3 = t2*t;

  float a0 = -0.5f*t3 + t2 - 0.5f*t;
  float a1 =  1.5f*t3 - 2.5f*t2 + 1.0f;
  float a2 = -1.5f*t3 + 2.0f*t2 + 0.5f*t;
  float a3 =  0.5f*t3 - 0.5f*t2;

  return new PVector(
    a0*p0.x + a1*p1.x + a2*p2.x + a3*p3.x,
    a0*p0.y + a1*p1.y + a2*p2.y + a3*p3.y,
    a0*p0.z + a1*p1.z + a2*p2.z + a3*p3.z
  );
}

PVector cubicBezierPoint(PVector p0, PVector p1, PVector p2, PVector p3, float t) {
  float mt = 1 - t;
  return new PVector(
    mt*mt*mt*p0.x + 3*mt*mt*t*p1.x + 3*mt*t*t*p2.x + t*t*t*p3.x,
    mt*mt*mt*p0.y + 3*mt*mt*t*p1.y + 3*mt*t*t*p2.y + t*t*t*p3.y,
    mt*mt*mt*p0.z + 3*mt*mt*t*p1.z + 3*mt*t*t*p2.z + t*t*t*p3.z
  );
}

boolean isOnCircuit(float x, float y, float z) {
  if(samplePoints == null) { return false; }
    for(PVector p : samplePoints) {
        float dist = dist(x, y, z, p.x, p.y, p.z);
        if(dist < largeurRoute) { return true; }
    } return false;
}