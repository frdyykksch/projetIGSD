
class Minimap {
    PGraphics minimapBuffer;
    Circuit c;
    ArrayList<PVector> points;
    float minX, maxX, minZ, maxZ, scale;
    float mapSize = 150;
    float mapX, mapY;
    
    Minimap(Circuit c) {
        this.c = c;
        this.points = c.samplePoints;
        minimapBuffer = createGraphics(150, 150);
        calculateBounds();
    }
    
    void calculateBounds() {
        minX = points.get(0).x;
        maxX = points.get(0).x;
        minZ = points.get(0).z;
        maxZ = points.get(0).z;
        
        for(PVector p : points) {
            minX = min(minX, p.x);
            maxX = max(maxX, p.x);
            minZ = min(minZ, p.z);
            maxZ = max(maxZ, p.z);
        }
        
        scale = mapSize / max(maxX - minX, maxZ - minZ);
    }
    
    void drawCircuitMapSetup(float size, float x, float y) {
        mapSize = size;
        mapX = x;
        mapY = y;
        
        minimapBuffer.beginDraw();
        minimapBuffer.hint(DISABLE_DEPTH_TEST);
        minimapBuffer.background(0, 0, 0, 100);
        
        // Draw circuit track
        minimapBuffer.stroke(255);
        minimapBuffer.strokeWeight(2);
        minimapBuffer.noFill();
        minimapBuffer.beginShape();
        for(PVector p : points) {
            float px = (p.x - minX) * scale;
            float pz = (p.z - minZ) * scale;
            minimapBuffer.vertex(px, pz);
        }
        minimapBuffer.endShape(CLOSE);
        minimapBuffer.hint(ENABLE_DEPTH_TEST);
        minimapBuffer.endDraw();
        println(c.samplePoints.size());
    }
    
    void drawMinimap(float x, float y, boolean isNight, Car car1, ArrayList<Police> carsPolice) {
        hint(DISABLE_DEPTH_TEST);
        
        // Draw the pre-rendered circuit map
        image(minimapBuffer, x, y);
        
        // Draw car1 (red)
        fill(255, 0, 0);
        strokeWeight(2);
        pushMatrix();
        translate(x + (car1.pos.x - minX) * scale, y + (car1.pos.z - minZ) * scale);
        rotate(car1.yaw);
        triangle(-10, -6, -10, 6, 10, 0);
        popMatrix();
        
        // Draw all police cars in the arrayList
        for(Police cp : carsPolice) {
            if(isNight) {
                fill(255, 255, 255);
            } else {
                fill(0, 0, 255);
            }
            strokeWeight(2);
            pushMatrix();
            translate(x + (cp.pos.x - minX) * scale, y + (cp.pos.z - minZ) * scale);
            rotate(cp.yaw);
            triangle(-10, -6, -10, 6, 10, 0);
            popMatrix();
        }
        
        hint(ENABLE_DEPTH_TEST);
    }
}