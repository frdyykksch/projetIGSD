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
  stroke(1);
  noFill();
  textureMode(IMAGE);
  rotateX(PI/2);

  int tileWidth = 20;
  int tileHeight = 80;

  pushMatrix();
  for(int i = 0; i < pointsCircuit.size() - 1; i++) {
    PVector pStart = pointsCircuit.get(i);
    PVector pEnd = pointsCircuit.get(i+1);

    int dist = floor(pStart.dist(pEnd));

    PVector dir = PVector.sub(pEnd, pStart);
    float angle = atan2(dir.y, dir.x);

    pushMatrix();
    translate(pStart.x, pStart.y);
    rotateZ(angle);

    for(int k = 0; k < dist; k += tileHeight) {
      pushMatrix();

      translate(k, 0);
      drawTile(tileHeight, tileWidth);

      popMatrix();
    } popMatrix();
  } popMatrix();
}

void drawTile(int tileHeight, int tileWidth) {
  rotateZ(PI/2.);
  beginShape(QUADS);
  vertex(0, 0, 0);
  vertex(tileHeight, 0, 0);
  vertex(tileHeight, tileWidth, 0);
  vertex(0, tileWidth, 0);
  endShape();
}