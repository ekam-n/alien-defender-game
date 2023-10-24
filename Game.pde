// Assignment 2
// Part 3
// Whack-A-Mole-like Game

int LENGTH = 801;


// global Fills for background
color neptune = color(20, 65, 205);
color saturn = color(180, 150, 80);
color sun = color(255, 135, 0);

// global Strokes for background
color neptuneStroke = color(4, 30, 115);
color saturnStroke = color(180, 130, 5);
color saturnRings = color(65, 45, 5);
color sunStroke = color(145, 80, 0);

Satellite satellite;

// aliens arraylist and size info
ArrayList<Alien> aliens;
int alienWidth = 125;
int alienHeight = 60;

// Score object
Score playerScore;

// player variables
int ammo = 10;
int hitCounter = 0; // checks for a hit

// timers
int respawnTimer = -1;
int ammoIncreaseGraphicTimer = -1;
int diffIncreaseGraphicTimer = -1;

// difficulty level
int diffScale = 0;
float speedMultiplier = 1;
int directionChangeTimer = -1; // how long the time between direction changes is
int directionChangeTimerIncrement = -1;
int directionChanger = 1;

// game state flags
int startFlag = -1;
int rulesFlag = -1;
int gameEndFlag = -1;


void setup() {
  
  size(800, 800);

  aliens = new ArrayList<Alien>();
  satellite = new Satellite();
  playerScore = new Score();
  PFont font = loadFont("PublicPixel-48.vlw");
  textFont(font);
  textSize(30);

  // muliplying width and height by 2 here because I scaled by 0.5 in drawAlien()
  for ( int i = 0; i < 10; i++ ) {
    Alien currAlien = new Alien( (int)random(0 + alienWidth/2, width - alienWidth/2), (int)random(0 + alienHeight/2, height - alienHeight/2) );
    aliens.add(currAlien);
  }
}


void draw() {

  drawBackground();
  
  satellite.findMetrics(mouseX, mouseY);
  
  if ( startFlag == - 1 && rulesFlag == -1 && gameEndFlag == -1) {

    cursor();
    drawStartScreen();
    // rect(width/2 -250, height/2 -40, 230, 60);
    //rect(width/2 + 20 , height/2 - 40, 230, 60);

    if ( mousePressed && mouseX > width/2 -250 && mouseX < width/2 -20 && mouseY > height/2 - 40
      && mouseY < height/2 + 20 ) {

      startFlag = 0;
    } else if (mousePressed && mouseX > width/2 + 20 && mouseX < width/2 + 250 && mouseY > height/2 -40
      && mouseY < height/2 + 20) {

      rulesFlag = 0;
    }
  } else if ( startFlag == 0 ) {

    noCursor();

    if ( ammo > 0 ) {

      for (int i = 0; i < aliens.size(); i++) {

        Alien currAlien = aliens.get(i);

        currAlien.move();
        currAlien.drawAlien();
      }
      diffScale();
      directionChange();
      respawn();
    }

    drawHUD();
    drawAmmoIncrease();
    drawDiffIncrease();
    satellite.blastAnimation(mousePressed);
    satellite.drawSatt();
    drawTarget();

    if ( ammo == 0 ) {

      gameEndFlag = 0;
      startFlag = -1;
    }
  } else if ( rulesFlag == 0 ) {

    cursor();
    drawRules();

    //rect(width/2-250, height/2 + 50, 250, 60);
    if (mousePressed && mouseX > width/2-250 && mouseX < width/2
      && mouseY -100> height/2 + 50 && mouseY-100 < height/2 +110) {

      rulesFlag = -1;
    }
  } else if ( gameEndFlag == 0 ) {

    cursor();
    drawHUD();
    drawEndScreen();
    //rect(width/2 + 25, height/2 + 250, 325,75);
    if ( mousePressed && mouseX > width/2 + 25 && mouseX < width/2 + 350
      && mouseY > height/2 + 250 && mouseY < height/2 + 325) {

      gameEndFlag = -1;
      ammo = 10;
      diffScale = 0;
      speedMultiplier = 1;
      directionChangeTimer = -1;
      directionChangeTimerIncrement = -1;
      directionChanger = -1;
      playerScore.score = 0;
      aliens = new ArrayList<Alien>();
      for (int i = 0; i < 10; i++) {

        Alien currAlien = new Alien( (int)random(0 + alienWidth/2, width - alienWidth/2),
          (int)random(0 + alienHeight/2, height - alienHeight/2) );
        aliens.add(currAlien);
      }
    }
  }

  //println(playerScore.get(), aliens.size(), ammo);
}

void mousePressed() {

  int missFlag = 1;

  if ( startFlag == 0 ) {

    for (int i = 0; i < aliens.size(); i++) {

      Alien currAlien = aliens.get(i);

      if ( currAlien.isAlive() && mouseX > currAlien.xPosition - alienWidth/2 && mouseX < currAlien.xPosition + alienWidth/2
        && mouseY > currAlien.yPosition - alienHeight/2 && mouseY < currAlien.yPosition + alienHeight/2 ) {

        currAlien.kill();
        playerScore.add();
        missFlag = -1;
        hitCounter++;
      }
    }

    if (ammo > 0 && missFlag == 1 ) {

      ammo--;
      hitCounter = 0;
    }

    if ( hitCounter >= 3 ) {

      ammo++;
      hitCounter = 0;
      if ( ammoIncreaseGraphicTimer == -1 ) {

        ammoIncreaseGraphicTimer = 60;
      }
    }
  }
}

void drawDiffIncrease() {

  if ( diffIncreaseGraphicTimer > 0 ) {

    fill(240, 5, 5);
    textSize(20);
    text("DIFFICULTY INCREASE!", 30, 200);
    diffIncreaseGraphicTimer--;
  } else if ( diffIncreaseGraphicTimer == 0 ) {

    diffIncreaseGraphicTimer = -1;
  }
}

void drawAmmoIncrease() {

  if ( ammoIncreaseGraphicTimer > 0 ) {

    fill(255, 240, 0);
    textSize(20);
    text("+1 CHARGE!", 30, 160);
    ammoIncreaseGraphicTimer--;
  } else if ( ammoIncreaseGraphicTimer == 0 ) {

    ammoIncreaseGraphicTimer = -1;
  }
}

void drawEndScreen() {

  fill(160, 10, 20);
  textSize(50);
  text("GAME OVER!", width/2 - 225, height/2);

  fill(0);
  stroke(255);
  strokeWeight(5);
  rect(width/2 + 25, height/2 + 250, 325, 75);

  fill(160, 10, 20);
  textSize(30);
  text("MAIN MENU", width/2 + 55, height/2 +300);
}

void drawRules() {

  //welcome to alien defender!
  // Kill as many aliens as you can
  // You have 10 charges
  // missing an alien takes away a charge
  // killing 3 aliens in a row builds a charge
  // the more aliens you kill, the harder they are to hit

  pushMatrix();
  translate(0, 100);

  fill(0);
  stroke(255);
  strokeWeight(5);
  rect(width/2-250, height/2-300, 500, 320);
  rect(width/2-250, height/2 + 50, 250, 60);


  fill(0, 170, 20);
  textSize(18);
  text("WELCOME TO ALIEN DEFENDER!", width/2- 230, height/2 - 250);
  textSize(12);
  text("KILL AS MANY ALIENS AS YOU CAN!", width/2-230, height/2 - 180);
  text("YOU HAVE 10 CHARGES", width/2-230, height/2 - 140);
  text("IF YOU MISS, -1 CHARGE", width/2-230, height/2 - 100);
  text("IF YOU GET 3 IN A ROW, +1 CHARGE", width/2-230, height/2 - 60);
  text("THE MORE YOU KILL, THE HARDER IT GETS!", width/2-230, height/2 - 20);

  textSize(30);
  text("GO BACK", width/2-230, height/2 + 92.5);

  popMatrix();
}

void drawStartScreen() {

  fill(0);
  stroke(255);
  strokeWeight(5);
  rect(width/2-250, height/2-120, 500, 60);
  rect(width/2 -250, height/2 -40, 230, 60);
  rect(width/2 + 20, height/2 - 40, 230, 60);

  fill(0, 170, 20);
  textSize(32);
  text("ALIEN DEFENDER", width/2 - 225, height/2 - 75);

  textSize(30);
  text("PLAY", width/2 - 200, height/2 +5 );
  text("RULES", width/2 + 60, height/2 +5);
}

void drawHUD() {

  fill(55, 173, 168);
  stroke(255);
  strokeWeight(3);
  rect(20, 20, 245, 100);

  fill(255);
  textSize(25);
  text("SCORE "+playerScore.get(), 30, 55);
  text("CHARGE " +ammo, 30, 100);
}



void respawn() {

  if ( aliens.size() > 5 && aliens.size() < 10 ) {

    if ( respawnTimer == -1 ) {

      respawnTimer = 60;
    } else if ( respawnTimer > 0 ) {

      respawnTimer--;
    } else {

      Alien currAlien = new Alien( (int)random(0 + alienWidth/2, width - alienWidth/2), (int)random(0 + alienHeight/2, height - alienHeight/2) );
      aliens.add(currAlien);
      respawnTimer = -1;
    }
  } else if ( aliens.size() > 2 && aliens.size() < 6 ) {

    if ( respawnTimer == -1 ) {

      respawnTimer = 30;
    } else if ( respawnTimer > 0 ) {

      respawnTimer--;
    } else {

      Alien currAlien = new Alien( (int)random(0 + alienWidth/2, width - alienWidth/2), (int)random(0 + alienHeight/2, height - alienHeight/2) );
      aliens.add(currAlien);
      respawnTimer = -1;
    }
  } else if ( aliens.size() < 3 ) {

    if ( respawnTimer == -1 ) {

      respawnTimer = 15;
    } else if ( respawnTimer > 0 ) {

      respawnTimer--;
    } else {

      Alien currAlien = new Alien( (int)random(0 + alienWidth/2, width - alienWidth/2), (int)random(0 + alienHeight/2, height - alienHeight/2) );
      aliens.add(currAlien);
      respawnTimer = -1;
    }
  }
}


void drawTarget() {

  noFill();
  stroke(255, 0, 0);
  strokeWeight(5);
  ellipse(mouseX, mouseY, 50, 50);

  fill(255, 0, 0);
  strokeWeight(5);
  line(mouseX - 35, mouseY, mouseX + 35, mouseY);
  line(mouseX, mouseY-35, mouseX, mouseY+35);
}

void diffScale() {

  if ( playerScore.get() == 100 && diffScale == 0 ) {

    speedMultiplier = 1.5;
    diffScale++;
    diffIncreaseGraphicTimer = 60;
  } else if ( playerScore.get() == 200 && diffScale == 1 ) {

    directionChangeTimer = 300;
    directionChangeTimerIncrement = 300;
    diffScale++;
    diffIncreaseGraphicTimer = 60;
  } else if ( playerScore.get() == 300 && diffScale == 2 ) {

    speedMultiplier = 2;
    diffScale++;
    diffIncreaseGraphicTimer = 60;
  } else if ( playerScore.get() == 400 && diffScale == 3 ) {

    directionChangeTimer = 150;
    directionChangeTimerIncrement = 150;
    diffScale++;
    diffIncreaseGraphicTimer = 60;
  }
}

void directionChange() {

  if ( directionChangeTimerIncrement == -1 ) {
  } else if ( directionChangeTimerIncrement > 0 ) {

    directionChangeTimerIncrement--;
  } else {

    directionChanger *= -1;
    directionChangeTimerIncrement = directionChangeTimer;
  }
}



void drawBackground() {

  background(0);

  // drawing neptune
  pushMatrix();
  translate(150, 400);
  fill(neptune);
  stroke(neptuneStroke);
  strokeWeight(6);
  ellipse(0, 0, 250, 230);
  strokeWeight(5);
  curve(0, -400, -100, -20, 0, 90, 200, -30);
  popMatrix();

  // drawing saturn
  pushMatrix();
  translate(700, 600);
  noFill();
  strokeWeight(40);
  stroke(saturnRings);
  curve(-500, 300, -250, 0, -150, 0, -500, 300);
  curve(500, 300, 270, 0, 150, 0, 500, 300);
  fill(saturn);
  stroke(saturnStroke);
  strokeWeight(8);
  ellipse(0, 0, 350, 320);
  strokeWeight(40);
  stroke(saturnRings);
  noFill();
  curve(-150, -450, -250, 0, 270, 0, 300, -200);
  popMatrix();

  // draw the sun

  pushMatrix();
  translate(700, 70);

  //triangles part
  pushMatrix();
  translate(-150, -50);

  stroke(sunStroke);
  strokeWeight(10);
  fill(sun);
  triangle(0, 0, 0, 50, -100, 25);

  translate(0, 80);
  rotate(-PI/6);
  triangle(0, 0, 0, 50, -100, 25);

  translate (0, 80);
  rotate(-PI/6);
  triangle(0, 0, 0, 50, -100, 25);

  translate(10, 90);
  rotate(-PI/6);
  triangle(0, 0, 0, 50, -100, 25);

  translate(10, 90);
  rotate(-PI/6);
  triangle(0, 0, 0, 50, -100, 25);

  popMatrix();

  //circle part
  stroke(sunStroke);
  strokeWeight(20);
  fill(sun);
  arc(0, 0, 300, 300, 0, PI, OPEN);
  arc(0, 0, 300, 300, PI, 2*PI, OPEN);

  popMatrix();
}
