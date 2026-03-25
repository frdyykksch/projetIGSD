PShape carModel;

void setupCar() {
  carModel = loadShape("..\\resources\\Car2.obj"); 
}

void drawCar() {
  pushMatrix();
    translate(0, 0, 0);
    scale(10.);
    
    rotateX(PI);
    rotateY(PI);
    
    shape(carModel);
  popMatrix();
}
