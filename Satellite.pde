class Satellite {
  
  int LENGTH = 801;
  
  // global strokes and fills for satt
  color sattStroke = color(150, 150, 150);
  color satt = color(210, 210, 210);
  color sattPanels = color(20, 7, 70);

  // Satellite variables
  float rotateSat;
  float barrelX = 120;
  float barrelY = 590;
  float laserLength;
  float offsetX;
  float offsetY;
  float angle;
  
  int blastAnimationTimer = -1;
  
  void findMetrics(int xPos, int yPos) {
    // ----------------------
    // SATELITE ANGLE PHYSICS 
    // ----------------------
    
    offsetX = abs(xPos - barrelX);
    offsetY = (barrelY + 120) - yPos;
    angle = (PI / 2) - atan(offsetY / (offsetX + 0.1));
    
    if (xPos < barrelX) {
      angle *= -1;
    }
    
    //println("X:", offsetX, " Y: ", offsetY);
    //println(angle * (180/PI));
    
    rotateSat = angle;
    
    // ------------------------
    // SATELITE LASER PHYSICS
    // ------------------------
    
    laserLength = sqrt(pow(offsetX, 2) + pow(offsetY, 2));
    
    println("Laser: " , laserLength);
    
    // ------------------------
  }
  
  void blastAnimation(boolean mousePressed) {
  
  
  int laserX = 0;
  int laserY = 0;
  int laserWidth = 2;

  pushMatrix();
  translate(barrelX - laserWidth, barrelY + 120);
  rotate(rotateSat);

  if ( mousePressed && blastAnimationTimer == -1 ) {

    blastAnimationTimer = 15;
  } else if ( blastAnimationTimer > 0 ) {
    
    
    laserLength = laserLength * -1;
    

    strokeWeight(5);
    stroke(255, 0, 240);
    fill(255, 0, 240);
    
    rect(laserX, laserY, laserWidth, laserLength);
    
    blastAnimationTimer--;
  } else if ( blastAnimationTimer == 0 && !mousePressed) {

    blastAnimationTimer = -1;
  }

  popMatrix();
}

  void drawSatt() {
  
    // drawing sattelite
    pushMatrix();
  
    translate(120, 710);
  
    rotate(rotateSat + (PI));
    scale(0.5);
  
    pushMatrix();
    translate(-50, -50);
  
    stroke(sattStroke);
    strokeWeight(7);
    fill(satt);
    line(50, -10, 50, 200);
    strokeWeight(3);
    rect(90, 65, 20, 5);
    rect(-10, 65, 20, 5);
    fill(sattPanels);
    quad(110, 20, 250, 20, 250, 120, 110, 120);
    line(140, 25, 140, 115);
    line(165, 25, 165, 115);
    line(190, 25, 190, 115);
    line(215, 25, 215, 115);
    int i = 0;
    while (i  < 3 ) {
      line(115, 45 + 25*i, 245, 45 + 25*i);
      i++;
    }
    stroke(sattStroke);
    quad(-150, 20, -10, 20, -10, 120, -150, 120);
    line(-120, 25, -120, 115);
    line(-95, 25, -95, 115);
    line(-70, 25, -70, 115);
    line(-45, 25, -45, 115);
    line(-145, 45, -15, 45);
    line(-145, 70, -15, 70);
    line(-145, 95, -15, 95);
    fill(satt);
    strokeWeight(3);
    ellipse(50, -15, 15, 15);
    stroke(sattStroke);
    fill(satt);
    strokeWeight(3);
    rect(0, 0, 100, 10);
    rect(10, 10, 80, 120);
    rect(20, 130, 60, 20);
    arc(50, 180, 80, 40, PI, 2*PI, CLOSE);
    //arc(50, 200, 20, 15, 0, PI, CLOSE);
  
    strokeWeight(5);
    stroke(0);
    line(70, 30, 70, 110);
  
  
  
    popMatrix();
  
    popMatrix();
  }
  
  
}
