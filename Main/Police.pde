class Police extends Vehicle {
    int targetIndex = 0;

    Police(PApplet parent, float x, float y, float z, String modelPath) {
        super.pos = new PVector(x, y, z);
        super.yaw = 0;
        super.speed = 3;
        super.oldY = y;
        super.vy = 0;
        super.model = loadShape(modelPath);
    }

    void update(Circuit c, Car player) {
        // Simple AI: follow waypoints
        if (targetIndex >= c.samplePoints.size()) targetIndex = 0;
        PVector target = c.samplePoints.get(targetIndex);
        PVector dir = PVector.sub(target, pos);
        float distSquared = dir.x * dir.x + dir.z * dir.z;

        if (distSquared < 3600) { // 60 squared
            targetIndex = (targetIndex + 1) % c.samplePoints.size();
            target = c.samplePoints.get(targetIndex);
            dir = PVector.sub(target, pos);
        }

        dir.normalize();
        float targetYaw = atan2(dir.z, dir.x);
        float delta = targetYaw - yaw;
        while (delta > PI) delta -= TWO_PI;
        while (delta < -PI) delta += TWO_PI;
        yaw += delta * 0.9; // smooth progressive rotation
        
        // movement - simple like Car class
        pos.x += speed * cos(yaw);
        pos.z += speed * sin(yaw);
        oldY = pos.y;
        // Get road Y position
        float roadY = c.getRoadY(pos.x, pos.y, pos.z);
        
        // gravity and collision
        if(c.isCollision(pos.x, pos.y, pos.z)) {
            pos.y = roadY;
            vy = 0;
        } else { 
            vy += g; 
            pos.y += vy; 
        }

        if(pos.y > 200) { 
            pos.set(startPos); 
            vy = 0;
            oldY = 0;
            yaw = 0;
            targetIndex = 0;
        } 

        // car collision
        PVector diff = PVector.sub(pos, player.pos);
        float collDistSquared = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;
        int maxDist = 35; 
        if (collDistSquared < maxDist * maxDist) {
            diff.normalize();
            pos.add(PVector.mult(diff, maxDist - sqrt(collDistSquared)));
        }
    }
}