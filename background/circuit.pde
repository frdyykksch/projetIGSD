ArrayList<PVector> pointsCircuit;
int segmentsParCourbe = 20;
float largeurRoute = 40;

void setupCircuit() {
  pointsCircuit = new ArrayList<PVector>();
  
  pointsCircuit.add(new PVector(0, 0));
  pointsCircuit.add(new PVector(400, 0));
  pointsCircuit.add(new PVector(600, 300));
  pointsCircuit.add(new PVector(400, 600));
  pointsCircuit.add(new PVector(0, 600));
  pointsCircuit.add(new PVector(-200, 300));
  pointsCircuit.add(new PVector(0, 0));
}

void drawCircuit() {
  noFill();
  stroke(255);
  rotateX(PI/2);
  
  for (int i = 0; i < pointsCircuit.size() - 1; i++) {
    PVector p1 = pointsCircuit.get(i);
    PVector p2 = pointsCircuit.get(i+1);
    
    beginShape(QUAD_STRIP); 
   
    for (int j = 0; j <= segmentsParCourbe; j++) {
      float t = j / (float)segmentsParCourbe;
      
      float x = lerp(p1.x, p2.x, t);
      float y = lerp(p1.y, p2.y, t);
      float z = lerp(p1.z, p2.z, t);

      PVector dir = PVector.sub(p2, p1).normalize();
      PVector ortho = new PVector(-dir.y, dir.x, 0).mult(largeurRoute);
      
      vertex(x + ortho.x, y + ortho.y, z);
      vertex(x - ortho.x, y - ortho.y, z);
    }
    endShape();
  }
}
