class Circuit {
  /*
   * ATTRIBUTES
   */
  String nomCircuit;
  ArrayList<PVector> points;
  ArrayList<PVector> samplePoints;
  float largeurRoute;
  int segmentsParCourbe = 1000;
  PImage roadTile;
  PImage fenceTexture;
  PShape circuitShape;
  PShape fenceShape;

  /*
   * CONSTRUCTORS
   */
  Circuit(String nomCircuit, ArrayList<PVector> points, int largeurRoute, String roadTileFile) {
    this.nomCircuit = nomCircuit; this.points = points; this.largeurRoute = largeurRoute; this.roadTile = loadImage(roadTileFile);
    this.samplePoints = sampleCircuit(segmentsParCourbe);
    setupCircuit();
  }

  Circuit() {
    points = new ArrayList<PVector>();

    points.add(new PVector(-500, 100, -1000));
    points.add(new PVector(500, 75, 500));
    points.add(new PVector(1500, -30, 750));
    points.add(new PVector(1000, -50, 1500));
    points.add(new PVector(0, -150, 1250));
    points.add(new PVector(-1000, 100, 1500));
    points.add(new PVector(0, -350, 3000));
    points.add(new PVector(2000, -160, 2500));
    points.add(new PVector(3000, -30, 2000));
    points.add(new PVector(2000, 65, 1000));
    points.add(new PVector(3000, -45, -500));
    points.add(new PVector(1000, -125, -1000));
    points.add(new PVector(-500, -125, 500));

    this.largeurRoute = 100;
    samplePoints = sampleCircuit(segmentsParCourbe);
    roadTile = loadImage("../resources/roadTile.jpg");
    fenceTexture = loadImage("../resources/startBanner/Fence.png");
    setupCircuit();
    setupFences(50, 80);
  }

  /*
   * METHODS
   */
  void setupCircuit() {
    circuitShape = buildStrip(roadTile, 0, roadTile.width, 0, roadTile.height / 80.0);
    setupFences(50, 80);
  }

  PShape buildStrip(PImage tex, float u1, float u2, float yOff, float yScale) {
    PShape strip = createShape();
    strip.beginShape(TRIANGLE_STRIP);
    strip.textureMode(IMAGE);
    strip.texture(tex);
    strip.noStroke();

    float vTex = 0;
    int m = samplePoints.size();

    for(int i = 0; i < m; i++) {
      PVector pt = samplePoints.get(i);
      PVector nextPt = samplePoints.get((i + 1) % m);

      PVector tangent = PVector.sub(nextPt, pt).normalize();
      PVector n = new PVector(-tangent.z, 0, tangent.x).normalize().mult(largeurRoute);

      PVector left = PVector.sub(pt, n);
      PVector right = PVector.add(pt, n);

      strip.vertex(left.x, left.y + yOff, left.z, u1, vTex);
      strip.vertex(right.x, right.y + yOff, right.z, u2, vTex);

      vTex += PVector.dist(pt, nextPt) * yScale;
    }
    PVector pStart = samplePoints.get(0);
    PVector pNext = samplePoints.get(1);
    PVector tangentStart = PVector.sub(pNext, pStart).normalize();
    PVector nStart = new PVector(-tangentStart.z, 0, tangentStart.x).normalize().mult(largeurRoute);

    strip.vertex(pStart.x - nStart.x, pStart.y + yOff, pStart.z - nStart.z, u1, vTex);
    strip.vertex(pStart.x + nStart.x, pStart.y + yOff, pStart.z + nStart.z, u2, vTex);

    strip.endShape();
    return strip;
  }

  void display() {
    textureWrap(REPEAT);
    shape(circuitShape);
    shape(fenceShape);
  }

  ArrayList<PVector> sampleCircuit(int stepsPerSegment) {
    ArrayList<PVector> sample = new ArrayList<PVector>();
    int n = points.size();
    float tension = 0.4;
  
    for(int i = 0; i < n; i++) {
      PVector p0 = points.get((i - 1 + n) % n);
      PVector p1 = points.get(i);
      PVector p2 = points.get((i + 1) % n);
      PVector p3 = points.get((i + 2) % n);
  
      PVector cp1 = PVector.add(p1, PVector.mult(PVector.sub(p2, p0), tension));
      PVector cp2 = PVector.sub(p2, PVector.mult(PVector.sub(p3, p1), tension));
  
      for(int s = 0; s < stepsPerSegment; s++) {
        float t = s / (float) stepsPerSegment;
        sample.add(cubicBezierPoint(p1, cp1, cp2, p2, t));
      }
    }
    return sample;
  }

  PVector cubicBezierPoint(PVector p0, PVector p1, PVector p2, PVector p3, float t) {
    float mt = 1 - t;
    return new PVector(
      mt*mt*mt*p0.x + 3*mt*mt*t*p1.x + 3*mt*t*t*p2.x + t*t*t*p3.x,
      mt*mt*mt*p0.y + 3*mt*mt*t*p1.y + 3*mt*t*t*p2.y + t*t*t*p3.y,
      mt*mt*mt*p0.z + 3*mt*mt*t*p1.z + 3*mt*t*t*p2.z + t*t*t*p3.z
    );
  }

  boolean isCollision(float x, float carY, float z) {
  if(samplePoints == null) return false;
  float yTolerance = 150;
  for(PVector p : samplePoints) {
    if(abs(p.y - carY) > yTolerance) continue;
    float dxz = dist(x, 0, z, p.x, 0, p.z);
    if(dxz < largeurRoute) return true;
  }
  return false;
}

  float getRoadY(float x, float carY, float z) {
    float closestDist = Float.MAX_VALUE;
    float closestY = carY;
    float yTolerance = 150;

    for(PVector p : samplePoints) {
      if(abs(p.y - carY) > yTolerance) continue;

      float d = dist(x, 0, z, p.x, 0, p.z);
      if(d < closestDist) {
        closestDist = d;
        closestY = p.y;
      }
    }
    return closestY;
  }

  PVector getSpawnPoint() {
    return this.points.get(0);
  }

  float getSpawnYaw() {
    PVector p0 = points.get(0);
    PVector p1 = points.get(1);
    return atan2(p1.z - p0.z, p1.x - p0.x);
  }

  PVector getLastPoint() {
    return this.points.get(this.points.size() - 1);
  }

  void lightCircuit(boolean isNight) {
    if(!isNight) {
      float circuitCenterX = 1000;
      float circuitCenterZ = 750;
      float lightHeight = -2000; // Very high above circuit
      pointLight(255, 255, 255, circuitCenterX, lightHeight, circuitCenterZ);
    }
  }

  void setupFences(float fenceHeight, float fenceWidth) {
    if(fenceTexture == null) return;

    fenceShape = createShape(GROUP);
    noStroke();

    float vScale = fenceTexture.height;

    PShape leftFence = buildFenceStrip(fenceTexture, 0, fenceWidth, vScale, 0, 0, fenceHeight);
    PShape rightFence = buildFenceStrip(fenceTexture, fenceTexture.width, fenceWidth, vScale, 0, 0, fenceHeight);

    fenceShape.addChild(leftFence);
    fenceShape.addChild(rightFence);
  }

  PShape buildFenceStrip(PImage tex, float u1, float u2, float yScale, float yOff1, float yOff2, float height) {
    PShape strip = createShape();
    strip.beginShape(TRIANGLE_STRIP);
    strip.textureMode(IMAGE);
    strip.texture(tex);
    strip.noStroke();

    float vTex = 0;
    int m = samplePoints.size();

    for(int i = 0; i < m; i++) {
      PVector pt = samplePoints.get(i);
      PVector nextPt = samplePoints.get((i + 1) % m);

      PVector tangent = PVector.sub(nextPt, pt).normalize();
      PVector n = new PVector(-tangent.z, 0, tangent.x).normalize().mult(largeurRoute);

      PVector left = PVector.sub(pt, n);
      PVector right = PVector.add(pt, n);

      strip.vertex(left.x, left.y + yOff1, left.z, u1, vTex);
      strip.vertex(left.x, left.y + yOff1 - height, left.z, u1, vTex + height * yScale);

      vTex += PVector.dist(pt, nextPt) * yScale;
    }
    PVector pStart = samplePoints.get(0);
    PVector pNext = samplePoints.get(1);
    PVector tangentStart = PVector.sub(pNext, pStart).normalize();
    PVector nStart = new PVector(-tangentStart.z, 0, tangentStart.x).normalize().mult(largeurRoute);

    strip.vertex(pStart.x - nStart.x, pStart.y + yOff1, pStart.z - nStart.z, u1, vTex);
    strip.vertex(pStart.x - nStart.x, pStart.y + yOff1 - height, pStart.z - nStart.z, u1, vTex + height * yScale);

    strip.endShape();
    return strip;
  }
}