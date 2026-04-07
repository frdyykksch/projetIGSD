class Props{
    PShape startEndBanner;
    float x, y, z;
    float angle;
    
    Props(PApplet parent, float x, float y, float z, int scale, String bannerPath) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.angle = PI; // Flip upside down
        startEndBanner = loadShape(bannerPath);
        startEndBanner.scale(scale);
    }
    
    void drawBanner() {
        if(startEndBanner != null) {
            pushMatrix();
            translate(x, y, z);
            rotateX(angle);
            shape(startEndBanner);
            popMatrix();
        }
    }
}