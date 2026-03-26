ArrayList<PVector> pointsCircuit;
int segmentsParCourbe = 20;
float largeurRoute = 40;
PImage roadTile;

void setupCircuit() {
  pointsCircuit = new ArrayList<PVector>();
  
  pointsCircuit.add(new PVector(0, 0));
  pointsCircuit.add(new PVector(400, 0));
  pointsCircuit.add(new PVector(600, 300));
  pointsCircuit.add(new PVector(400, 600));
  pointsCircuit.add(new PVector(0, 600));
  pointsCircuit.add(new PVector(-200, 300));
  pointsCircuit.add(new PVector(0, 0));
  
  roadTile = loadImage("..\\resources\\roadTile.jpg");
}

void drawCircuit() {
  noStroke();
  // noFill();
  // stroke(255);
  textureMode(IMAGE);
  stroke(2);
  noFill();
  rotateX(PI/2);

  int steps = 60;

  pushMatrix();
  for(int i = 0; i < pointsCircuit.size() - 1; i++) {
    PVector pStart = pointsCircuit.get(i);
    PVector pEnd   = pointsCircuit.get(i+1);
    PVector[] cps  = getControlPoints(pStart, pEnd, 0.25, -100.0, 0.75, -25.0);
    PVector cp1    = cps[0];
    PVector cp2    = cps[1];

    beginShape(TRIANGLE_STRIP);
    texture(roadTile);

    for(int s = 0; s <= steps; s++) {
      float t  = s / (float) steps;
      float t2 = min(t + 0.01, 1.0);

      PVector pt  = cubicBezierPoint(pStart, cp1, cp2, pEnd, t);
      PVector pt2 = cubicBezierPoint(pStart, cp1, cp2, pEnd, t2);

      PVector tangent = PVector.sub(pt2, pt);
      PVector vNorm    = new PVector(-tangent.y, tangent.x, 0);
      vNorm.normalize();
      vNorm.mult(largeurRoute / 1);

      PVector left  = PVector.sub(pt, vNorm);
      PVector right = PVector.add(pt, vNorm);

      float u0 = 0;
      float u1 = roadTile.width;
      float v  = (t * PVector.dist(pStart, pEnd) / 80.0) * roadTile.height % roadTile.height;

      vertex(left.x,  left.y,  0, u0, v);
      vertex(right.x, right.y, 0, u1, v);
    }
    endShape();
  } popMatrix();
}

// get controlpoints for point1 & point2 (first try only quadratic curves so only one controlpoint)
PVector[] getControlPoints(PVector p1, PVector p2, float tension1, float bow1, float tension2, float bow2) {
PVector dir = PVector.sub(p2, p1);
PVector vNorm = new PVector(-dir.y, dir.x, 0);
vNorm.normalize();

PVector mid1 = PVector.lerp(p1, p2, tension1);
PVector cp1  = PVector.add(mid1, PVector.mult(vNorm, bow1));

PVector mid2 = PVector.lerp(p1, p2, tension2);
PVector cp2  = PVector.add(mid2, PVector.mult(vNorm, bow2));

return new PVector[]{ cp1, cp2 };
}

PVector cubicBezierPoint(PVector p0, PVector p1, PVector p2, PVector p3, float t) {
  float mt = 1 - t;
  return new PVector(
    mt*mt*mt*p0.x + 3*mt*mt*t*p1.x + 3*mt*t*t*p2.x + t*t*t*p3.x,
    mt*mt*mt*p0.y + 3*mt*mt*t*p1.y + 3*mt*t*t*p2.y + t*t*t*p3.y,
    mt*mt*mt*p0.z + 3*mt*mt*t*p1.z + 3*mt*t*t*p2.z + t*t*t*p3.z
  );
}