class Props{
    PShape startEndBanner;
    float x, y, z;
    
    Props(PApplet parent, float x, float y, float z, String bannerPath) {
        this.x = x;
        this.y = y;
        this.z = z;
        startEndBanner = loadShape(bannerPath);
    }
    
    void drawBanner() {
        if(startEndBanner != null) {
            pushMatrix();
            translate(x, y, z);
            shape(startEndBanner);
            popMatrix();
        }
    }
}