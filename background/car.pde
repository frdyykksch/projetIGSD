PShape carModel;

void setupCar() {
  carModel = loadShape("C:\\Users\\frede\\Desktop\\Code\\UPS\\IGSD\\Projet\\projetIGSD\\resources\\Car.obj"); 

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
