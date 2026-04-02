ArrayList<PVector> vt = new ArrayList<PVector>();
void setupCircuit() {
    float s = 100;
    vt.add(new PVector(0, 0, s)); vt.add(new PVector(s, 0, s));
    vt.add(new PVector(s, s, s)); vt.add(new PVector(0, s, s));
    vt.add(new PVector(0, 0, 0)); vt.add(new PVector(0, s, 0));
    vt.add(new PVector(s, s, 0)); vt.add(new PVector(s, 0, 0));
    vt.add(new PVector(0, 0, 0)); vt.add(new PVector(0, 0, s));
    vt.add(new PVector(0, s, s)); vt.add(new PVector(0, s, 0));
    vt.add(new PVector(s, 0, 0)); vt.add(new PVector(s, s, 0));
    vt.add(new PVector(s, s, s)); vt.add(new PVector(s, 0, s));
    vt.add(new PVector(0, 0, 0)); vt.add(new PVector(s, 0, 0));
    vt.add(new PVector(s, 0, s)); vt.add(new PVector(0, 0, s));
    vt.add(new PVector(0, s, 0)); vt.add(new PVector(0, s, s));
    vt.add(new PVector(s, s, s)); vt.add(new PVector(s, s, 0));
}

void drawCircuit() {
    scale(100);
    stroke(255);
    strokeWeight(0.1);
    beginShape(QUADS);
    pushMatrix();
    for(PVector p : vt) {
        fill(255, 0, 0);
        vertex(p.x, p.y, p.z);
    }
    popMatrix();
    endShape();
}

boolean isOnCircuit(float x, float y, float z) {
    for(PVector p : vt) {
        float dist = dist(0, y, 0, p.y);
        println(dist);
        if(dist < 6) {
            return true;
        }
    } return false;
}