PShape carModel2;
void setupCar2() {
  carModel2 = loadShape("..\\resources\\PoliceCar.obj"); 
}
void drawCar2() {
  pushMatrix();
    translate(40, 0, -40);
    scale(10.);
    
    rotateX(PI);
    rotateY(PI);
    
    shape(carModel2);
  popMatrix();
}


