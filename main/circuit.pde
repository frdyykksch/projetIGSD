class Circuit {
  String nomCircuit;
  ArrayList<PVector> points;
  ArrayList<PVector> samplePoints;
  float largeurRoute;
  int segmentsParCourbe = 1000;
  PImage roadTile;
  PShape circuitShape;

  Circuit(String nomCircuit, ArrayList<PVector> points, int largeurRoute, String roadTileFile) {
    this.nomCircuit = nomCircuit; this.points = points; this.largeurRoute = largeurRoute; this.roadTile = loadImage(roadTileFile);
    this.samplePoints = sampleCircuit(segmentsParCourbe);
  }

  Circuit() {
    points = new ArrayList<PVector>();

    points.add(new PVector(0, 0, 0));
    points.add(new PVector(500, -50, 500));
    points.add(new PVector(1500, -30, 750));
    points.add(new PVector(1000, -50, 1500));
    points.add(new PVector(0, -75, 1250));
    points.add(new PVector(-1000, -125, 1500));
    points.add(new PVector(0, -125, 3000));
    points.add(new PVector(2000, -80, 2500));
    points.add(new PVector(3000, -30, 2000));
    points.add(new PVector(2000, -65, 1000));
    points.add(new PVector(3000, -45, -500));
    points.add(new PVector(1000, -65, -1000));

    this.largeurRoute = 100;
    samplePoints = sampleCircuit(segmentsParCourbe);
    roadTile = loadImage("..\\resources\\roadTile.jpg");
  }

  void setupCircuit() {
    circuitShape = createShape(GROUP);
    noStroke();

    PShape strip = createShape();
    strip.beginShape(TRIANGLE_STRIP);
    strip.textureMode(IMAGE);
    strip.texture(roadTile);
    strip.specular(150, 150, 150);
    strip.shininess(5);

    float vTex = 0;
    float vScale = roadTile.height / 80.0;
    int m = samplePoints.size();

    for(int i = 0; i < m; i++) {
      PVector pt = samplePoints.get(i);
      PVector nextPt = samplePoints.get((i + 1) % m);

      PVector tangent = PVector.sub(nextPt, pt);
      tangent.normalize();

      PVector n = new PVector(-tangent.z, 0, tangent.x);
      n.normalize();
      n.mult(largeurRoute);

      PVector left = PVector.sub(pt, n);
      PVector right = PVector.add(pt, n);

      strip.vertex(left.x, left.y, left.z, 0, vTex);
      strip.vertex(right.x, right.y, right.z, roadTile.width, vTex);

      vTex += PVector.dist(pt, nextPt) * vScale;
    }
    PVector pStart = samplePoints.get(0);
    PVector pNext = samplePoints.get(1);
    PVector tangentStart = PVector.sub(pNext, pStart);
    tangentStart.normalize();
    PVector nStart = new PVector(-tangentStart.z, 0, tangentStart.x);
    nStart.normalize().mult(largeurRoute);

    strip.vertex(pStart.x - nStart.x, pStart.y, pStart.z - nStart.z, 0, vTex);
    strip.vertex(pStart.x + nStart.x, pStart.y, pStart.z + nStart.z, roadTile.width, vTex);

    strip.endShape();
    circuitShape.addChild(strip);
  }

  void display() {
    textureWrap(REPEAT);
    shape(circuitShape);
  }

  ArrayList<PVector> sampleCircuit(int stepsPerSegment) {
    ArrayList<PVector> sample = new ArrayList<PVector>();
    int n = points.size();

    for(int i = 0; i < n; i++) {
      PVector p0 = points.get((i - 1 + n) % n);
      PVector p1 = points.get(i);
      PVector p2 = points.get((i + 1) % n);
      PVector p3 = points.get((i + 2) % n);

      for(int s = 0; s < stepsPerSegment; s++) {
        float t = s / (float) stepsPerSegment;
        sample.add(catmullRomPoint(p0, p1, p2, p3, t));
      }
    }
    // sample.add(sample.get(0).copy()); // removed because snap last to first wanst good
    // println(sample);
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

  boolean isCollision(float x, float y, float z) {
    if(samplePoints == null) { return false; }
      for(PVector p : samplePoints) {
          float dist = dist(x, y, z, p.x, p.y, p.z);
          if(dist < largeurRoute && p.y >= y) { return true; }
      } return false;
  }

  float getRoadY(float x, float z) {
    float closestDist = Float.MAX_VALUE;
    float closestY = 0;
    for(PVector p : samplePoints) {
      float d = dist(x, 0, z, p.x, 0, p.z);
      if(d < closestDist) {
        closestDist = d;
        closestY = p.y;
      }
    }
    println(closestY);
    return closestY;
  }

  PVector getSpawnPoint() {
    return this.points.get(0);
  }

  float getSpawnAngle() {
    PVector p0 = points.get(0);
    PVector p1 = points.get(1);
    return atan2(p1.z - p0.z, p1.x - p0.x);
  }
}