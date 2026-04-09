PShader fogShader;
PImage img; // Your game world or a background

void setup() {
  size(800, 600, P2D);
  fogShader = loadShader("fog.glsl");
}

void draw() {
  // Draw your game content here
  background(20, 40, 80); 
  fill(255);
  ellipse(mouseX, mouseY, 50, 50); // Just a "player" to see through fog

  // Update shader variables
  fogShader.set("u_time", millis() / 1000.0);
  fogShader.set("u_resolution", (float)width, (float)height);
  
  // Apply shader to the whole screen
  filter(fogShader); 
}