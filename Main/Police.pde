class Police extends Vehicle {
  /*
	 * ATTRIBUTES
	 */
  int targetIndex = 0;

	/*
   * CONSTRUCTORS
   */
  Police(PApplet parent, float x, float y, float z, float yaw, String modelPath) {
    super(new PVector(x, y, z), yaw);
    super.speed = 3;
    super.model = loadShape(modelPath);
  }

	/*
   * METHODS
   */
  void update(Circuit c, Car player) {
    if (targetIndex >= c.samplePoints.size()) targetIndex = 0;
    int size = c.samplePoints.size();
    int nearestIndex = targetIndex;
    float bestDistSq = Float.MAX_VALUE;
    int searchRadius = min(200, size - 1);

    for (int offset = -searchRadius; offset <= searchRadius; offset++) {
      int idx = (targetIndex + offset + size) % size;
      PVector sample = c.samplePoints.get(idx);
      float dx = sample.x - pos.x;
      float dz = sample.z - pos.z;
      float d2 = dx * dx + dz * dz;
      if (d2 < bestDistSq) {
        bestDistSq = d2;
        nearestIndex = idx;
      }
    }

    if (bestDistSq > 2500) {
      bestDistSq = Float.MAX_VALUE;
      for (int i = 0; i < size; i++) {
        PVector sample = c.samplePoints.get(i);
        float dx = sample.x - pos.x;
        float dz = sample.z - pos.z;
        float d2 = dx * dx + dz * dz;
        if (d2 < bestDistSq) {
          bestDistSq = d2;
          nearestIndex = i;
        }
      }
    }

    targetIndex = nearestIndex;
    int lookaheadSteps = min(30, size - 1);
    int lookaheadIndex = (targetIndex + lookaheadSteps) % size;
    PVector currentSample = c.samplePoints.get(targetIndex);
    PVector futureSample = c.samplePoints.get(lookaheadIndex);
    PVector trackDir = PVector.sub(futureSample, currentSample);
    trackDir.y = 0;
    trackDir.normalize();

    float desiredAngle = atan2(trackDir.z, trackDir.x);
    float delta = desiredAngle - yaw;
    while (delta > PI) delta -= TWO_PI;
    while (delta < -PI) delta += TWO_PI;
    yaw += delta * 0.1;

    pos.x += speed * cos(yaw);
    pos.z += speed * sin(yaw);
    oldY = pos.y;
    float roadY = c.getRoadY(pos.x, pos.y, pos.z);

    if (c.isCollision(pos.x, pos.y, pos.z)) {
      pos.y = roadY;
      vy = 0;
    } else {
      vy += g;
      pos.y += vy;
    }

    if (pos.y > 200) {
      pos.set(c.getSpawnPoint());
      vy = 0;
      oldY = 0;
      yaw = 0;
      targetIndex = 0;
    }

    PVector diff = PVector.sub(pos, player.pos);
    float collDistSquared = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;
    int maxDist = 35;
    if (collDistSquared < maxDist * maxDist) {
      diff.normalize();
      pos.add(PVector.mult(diff, maxDist - sqrt(collDistSquared)));
    }
  }
}
