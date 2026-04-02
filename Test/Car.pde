class Car {
  PVector trackPos; // x = index circuit (0 à N), y = décalage latéral (-1 à 1)
  float speed = 0;
  float laneOffset = 0; // Cible pour le déplacement fluide latéral
  PShape model;

  boolean isLeft, isRight, isUp, isDown;

  Car(float startIndex, String modelPath) {
    this.trackPos = new PVector(startIndex, 0);
    this.model = loadShape(modelPath);
  }

  void update() {
    // Accélération / Freinage
    if (isUp) speed += 0.002;
    else if (isDown) speed -= 0.002;
    speed *= 0.98; // Friction

    // Direction (Changement de file)
    if (isLeft)  laneOffset = lerp(laneOffset, -1.0, 0.1);
    else if (isRight) laneOffset = lerp(laneOffset, 1.0, 0.1);
    else laneOffset = lerp(laneOffset, 0, 0.05);
    
    trackPos.y = laneOffset;

    // Avancer sur le circuit (Modulo pour boucler)
    float n = pointsCircuit.size();
    trackPos.x = (trackPos.x + speed + n) % n;
  }

  // Convertit les coordonnées circuit en coordonnées 3D monde
  PVector getWorldPos(float t) {
    int n = pointsCircuit.size();
    int i = floor(t);
    float f = t - i;

    PVector p0 = pointsCircuit.get((i - 1 + n) % n);
    PVector p1 = pointsCircuit.get(i % n);
    PVector p2 = pointsCircuit.get((i + 1) % n);
    PVector p3 = pointsCircuit.get((i + 2) % n);

    // Position sur l'axe central
    PVector center = catmullRomPoint(p0, p1, p2, p3, f);

    // Calcul du vecteur perpendiculaire pour le décalage latéral
    PVector ahead = catmullRomPoint(p0, p1, p2, p3, f + 0.01);
    PVector tangent = PVector.sub(ahead, center);
    tangent.normalize();
    
    // Vecteur orthogonal (Normal) sur le plan XZ
    PVector lateral = new PVector(-tangent.z, 0, tangent.x);
    
    // Position finale : centre + (direction latérale * décalage * largeur)
    return PVector.add(center, PVector.mult(lateral, trackPos.y * largeurRoute));
  }

  void display() {
    PVector pos3D = getWorldPos(trackPos.x);
    PVector target = getWorldPos(trackPos.x + 0.05);
    
    float angle = atan2(target.z - pos3D.z, target.x - pos3D.x);

    pushMatrix();
    translate(pos3D.x, pos3D.y, pos3D.z);
    rotateX(PI);
    rotateY(PI - angle); // La voiture regarde vers le point suivant
    scale(10);
    shape(model);
    popMatrix();
  }
}