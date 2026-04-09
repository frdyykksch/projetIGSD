class Circuit {
  String nomCircuit;
  ArrayList<PVector> points;
  ArrayList<PVector> samplePoints;

  float largeurRoute;
  int segmentsParCourbe = 1000;

  PImage roadTile;
  PImage startCircuitTile;

  PShape circuitShape;

  PImage fenceTexture;
  PShape fenceShape;
  int fenceSegmentLength = 150;
  int fenceGapLength = 300;

  /*
   * CONSTRUCTORS
   */
  Circuit(String nomCircuit, ArrayList<PVector> points, int largeurRoute, String roadTileFile, String startEndTileFile) {
    this.nomCircuit = nomCircuit; this.points = points; this.largeurRoute = largeurRoute; this.roadTile = loadImage(roadTileFile); this.startCircuitTile = loadImage(startEndTileFile);
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
    startCircuitTile = loadImage("../resources/startTile.jpg");
    setupCircuit();
    setupFences(50, 80);
  }

  /*
   * METHODS
   */
  void setupCircuit() {
    circuitShape = createShape(GROUP);
    PShape startTile = buildStartTile(startCircuitTile, 0, startCircuitTile.width, 0, startCircuitTile.height / 80.0);
    circuitShape.addChild(startTile);
    PShape mainRoad = buildMainRoad(roadTile, 0, roadTile.width, 0, roadTile.height / 80.0);
    circuitShape.addChild(mainRoad);
    
    setupFences(50, 80);
  }

  PShape buildStartTile(PImage tex, float u1, float u2, float yOff, float yScale) {
    PShape strip = createShape();
    strip.beginShape(TRIANGLE_STRIP);
    strip.textureMode(IMAGE);
    strip.texture(tex);
    strip.noStroke();

    float vTex = 0;
    float tileHeight = tex.height;
    int m = samplePoints.size();
    int endIndex = 0;

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
      
      if(vTex >= tileHeight) {
        endIndex = i;
        break;
      }
    }
    
    PVector pEnd = samplePoints.get(endIndex);
    PVector pNext = samplePoints.get((endIndex + 1) % m);
    PVector tangentEnd = PVector.sub(pNext, pEnd).normalize();
    PVector nEnd = new PVector(-tangentEnd.z, 0, tangentEnd.x).normalize().mult(largeurRoute);

    strip.vertex(pEnd.x - nEnd.x, pEnd.y + yOff, pEnd.z - nEnd.z, u1, vTex);
    strip.vertex(pEnd.x + nEnd.x, pEnd.y + yOff, pEnd.z + nEnd.z, u2, vTex);

    strip.endShape();
    return strip;
  }

  PShape buildMainRoad(PImage tex, float u1, float u2, float yOff, float yScale) {
    PShape strip = createShape();
    strip.beginShape(TRIANGLE_STRIP);
    strip.textureMode(IMAGE);
    strip.texture(tex);
    strip.noStroke();

    float vTex = 0;
    float startTileHeight = startCircuitTile.height;
    int m = samplePoints.size();
    int startIndex = 0;

    for(int i = 0; i < m; i++) {
      PVector pt = samplePoints.get(i);
      PVector nextPt = samplePoints.get((i + 1) % m);
      float dist = PVector.dist(pt, nextPt) * yScale;
      vTex += dist;
      
      if(vTex >= startTileHeight) {
        startIndex = i;
        break;
      }
    }

    vTex = 0;
    for(int i = startIndex; i < m; i++) {
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

  PShape buildStrip(PImage tex, float u1, float u2, float yOff, float yScale) {
    PShape strip = createShape();
    strip.beginShape(TRIANGLE_STRIP);
    strip.textureMode(IMAGE);
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
      strip.texture(tex);
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
    for(PVector p : samplePoints) {
      float dxz = dist(x, 0, z, p.x, 0, p.z);
      if(dxz < largeurRoute) {
        if(carY >= p.y) return true;
      }
    } return false;
  }

  float getRoadY(float x, float carY, float z) {
    float closestDist = Float.MAX_VALUE;
    float closestY = carY;
    float yTolerance = 150; // circuit au dessus

    for(PVector p : samplePoints) {
      if(abs(p.y - carY) > yTolerance) continue;

      float d = dist(x, 0, z, p.x, 0, p.z);
      if(d < closestDist) {
        closestDist = d;
        closestY = p.y;
      }
    } return closestY;
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
      float lightHeight = -2000;
      pointLight(255, 255, 255, circuitCenterX, lightHeight, circuitCenterZ);
    }
  }

  void setupFences(float fenceHeight, float fenceWidth) {
    if(fenceTexture == null) return;

    fenceShape = createShape(GROUP);
    noStroke();

    float vScale = fenceTexture.height;

    PShape leftFence = buildFenceStrip(fenceTexture, 0, vScale, 0, fenceHeight, true);
    PShape rightFence = buildFenceStrip(fenceTexture, fenceTexture.width, vScale, 0, fenceHeight, false);

    fenceShape.addChild(leftFence);
    fenceShape.addChild(rightFence);
  }

  PShape buildFenceStrip(PImage tex, float uTex, float vScale, float yOff, float height, boolean isLeft) {
    PShape strip = createShape(GROUP);
    
    float vTex = 0;
    int m = samplePoints.size();
    int cycleLength = fenceSegmentLength + fenceGapLength;
    
    int i = 0;
    while(i < m) {
      int posInCycle = i % cycleLength;
      
      // Only render if in segment range, not in gap
      if(posInCycle < fenceSegmentLength) {
        PShape segmentStrip = createShape();
        segmentStrip.beginShape(TRIANGLE_STRIP);
        segmentStrip.textureMode(IMAGE);
        segmentStrip.texture(tex);
        segmentStrip.noStroke();
        
        vTex = 0;
        int segmentEnd = min(i + fenceSegmentLength, m);
        
        for(int j = i; j < segmentEnd; j++) {
          PVector pt = samplePoints.get(j);
          PVector nextPt = samplePoints.get((j + 1) % m);
          
          PVector tangent = PVector.sub(nextPt, pt).normalize();
          PVector n = new PVector(-tangent.z, 0, tangent.x).normalize().mult(largeurRoute);
          
          PVector edge = isLeft ? PVector.sub(pt, n) : PVector.add(pt, n);
          
          segmentStrip.vertex(edge.x, edge.y + yOff, edge.z, uTex, vTex);
          segmentStrip.vertex(edge.x, edge.y + yOff - height, edge.z, uTex, vTex + height * vScale);
          
          vTex += PVector.dist(pt, nextPt) * vScale;
        }
        
        segmentStrip.endShape();
        strip.addChild(segmentStrip);
        i = segmentEnd;
      } else {
        // Skip to next cycle
        i += fenceGapLength;
      }
    }
    
    return strip;
  }

  ArrayList<PVector>[] getFenceBoundaries() {
    ArrayList<PVector>[] fences = new ArrayList[2];
    fences[0] = new ArrayList<PVector>(); 
    fences[1] = new ArrayList<PVector>();
    
    int m = samplePoints.size();
    int cycleLength = fenceSegmentLength + fenceGapLength;
    
    int i = 0;
    while(i < m) {
      int posInCycle = i % cycleLength;
      
      // Only add collision points where fences actually are
      if(posInCycle < fenceSegmentLength) {
        int segmentEnd = min(i + fenceSegmentLength, m);
        
        for(int j = i; j < segmentEnd; j++) {
          PVector pt = samplePoints.get(j);
          PVector nextPt = samplePoints.get((j + 1) % m);
          
          PVector tangent = PVector.sub(nextPt, pt).normalize();
          PVector n = new PVector(-tangent.z, 0, tangent.x).normalize().mult(largeurRoute);
          
          PVector leftFence = PVector.sub(pt, n);
          PVector rightFence = PVector.add(pt, n);
          
          fences[0].add(leftFence);
          fences[1].add(rightFence);
        }
        
        i = segmentEnd;
      } else {
        // Skip to next cycle
        i += fenceGapLength;
      }
    }
    
    return fences;
  }
}