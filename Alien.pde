class Alien {

  int xPosition;
  int yPosition;
  float xSpeed;
  float ySpeed;
  int deathTimer;
  int fireChangeTimer; // checks when to change the fire in death animation

  Alien(int xPosition, int yPosition) {

    this.xPosition = xPosition;
    this.yPosition = yPosition;
    deathTimer = -1;
    fireChangeTimer = 0;

    xSpeed = random(-7, 7) * speedMultiplier;
    //make sure xspeed only between -7,-3 and 3,7
    if ( xSpeed < 0 && xSpeed > -3 ) {
      xSpeed -= 3;
    } else if ( xSpeed > 0 && xSpeed < 3 ) {
      xSpeed += 3;
    } else if ( xSpeed == 0 ) {
      xSpeed = 4;
    }


    ySpeed = random(-7, 7) * speedMultiplier;
    //make sure yspeed only between -7,-3 and 3,7
    if ( ySpeed < 0 && ySpeed > -3 ) {
      ySpeed -= 3;
    } else if ( ySpeed > 0 && ySpeed < 3 ) {
      ySpeed += 3;
    } else if ( ySpeed == 0 ) {
      ySpeed = 4;
    }
  }

  void move() {

    if ( isAlive() ) {

      detectWall();
      xPosition += xSpeed * directionChanger;
      yPosition += ySpeed * directionChanger;
    }
  }

  void drawAlien() {

    pushMatrix();

    if ( isAlive() ) {

      translate(xPosition, yPosition);

      //UFO
      fill(155, 165, 235);
      stroke(0);
      strokeWeight(1/2);
      arc(0, 0, 100/2, 80/2, PI, 2*PI, OPEN);

      fill(115, 40, 235);
      curve( -700/2, - 10/2, 50/2, 0, 0, 60/2, - 800/2, 50/2);
      curve(  700/2, -10/2, - 50/2, 0, 0, 60/2, 800/2, 50/2);

      strokeWeight(1);
      stroke(0);
      triangle( 50/2, 0, -50/2, 0, 0, 60/2);

      stroke(0);
      strokeWeight(1/2);
      fill(155, 165, 235);
      arc(0, 0, 100/2, 40/2, 0, PI, OPEN);

      //alien

      fill(20, 190, 10);
      stroke(0);
      strokeWeight(1);
      arc(0, -20/2, 50/2, 40/2, PI, 2*PI, OPEN);
      arc(0, -20/2, 50/2, 80/2, 0, PI, OPEN);

      pushMatrix();
      translate(-5, -10/2);
      rotate(-PI/8);
      fill(0);
      stroke(0);
      strokeWeight(1/2);
      ellipse(0, 0, 7, 30/2);
      popMatrix();

      pushMatrix();
      translate(5, -10/2);
      rotate(PI/8);
      fill(0);
      stroke(0);
      strokeWeight(1/2);
      ellipse(0, 0, 7, 30/2);
      popMatrix();
    } else {

      if ( deathTimer > 150 ) {

        drawHitEffect();
        deathTimer--;
      } else if ( deathTimer > 0 ) {

        drawDyingAnimation();
        deathTimer--;
      } else if ( deathTimer == 0 ) {

        aliens.remove(this);
      }
    }
    popMatrix();
  }

  void detectWall() {

    if ( xPosition >= (width + alienWidth/2) ) {

      xPosition = -alienWidth/2;
    } else if ( xPosition <= -alienWidth/2 ) {

      xPosition = width + alienWidth/2 ;
    } else if ( yPosition >= (height + alienHeight/2) ) {

      yPosition = -alienHeight/2;
    } else if ( yPosition <= -alienHeight/2 ) {

      yPosition = height + alienHeight/2 ;
    }
  }

  void kill() {

    xSpeed = 0;
    ySpeed = 0;
    deathTimer = 180;
  }


  boolean isAlive() {

    return deathTimer == -1;
  }

  void drawHitEffect() {

    fill(225, 90, 0);
    stroke(225, 90, 0);
    strokeWeight(0);
    triangle(xPosition -30, yPosition, xPosition-30, yPosition-30,
      xPosition + 10, yPosition);
    triangle(xPosition + 30, yPosition, xPosition + 30, yPosition-30,
      xPosition - 10, yPosition);
    triangle(xPosition + 30, yPosition, xPosition + 70, yPosition + 10,
      xPosition + 30, yPosition + 20);
    triangle(xPosition -30, yPosition + 20, xPosition-30, yPosition+50,
      xPosition + 10, yPosition + 20);
    triangle(xPosition + 30, yPosition + 20, xPosition + 30, yPosition+50,
      xPosition - 10, yPosition + 20);
    triangle(xPosition - 30, yPosition, xPosition - 70, yPosition + 10,
      xPosition - 30, yPosition + 20);
    rect(xPosition - 30, yPosition, 60, 20);
  }

  void drawDyingAnimation() {

    pushMatrix();
    translate(xPosition, yPosition);

    //UFO
    fill(155, 165, 235);
    stroke(0);
    strokeWeight(1/2);
    arc(0, 0, 100/2, 80/2, PI, 2*PI, OPEN);

    fill(115, 40, 235);
    curve( -700/2, - 10/2, 50/2, 0, 0, 60/2, - 800/2, 50/2);
    curve(  700/2, -10/2, - 50/2, 0, 0, 60/2, 800/2, 50/2);

    strokeWeight(1);
    stroke(0);
    triangle( 50/2, 0, -50/2, 0, 0, 60/2);

    stroke(0);
    strokeWeight(1/2);
    fill(155, 165, 235);
    arc(0, 0, 100/2, 40/2, 0, PI, OPEN);

    //alien

    fill(20, 190, 10);
    stroke(0);
    strokeWeight(1);
    arc(0, -20/2, 50/2, 40/2, PI, 2*PI, OPEN);
    arc(0, -20/2, 50/2, 80/2, 0, PI, OPEN);

    fill(0);
    stroke(0);
    strokeWeight(2);
    line(-10, -12, -2, 0);
    line(10, -12, 2, 0);
    line(-10, 0, -2, -12);
    line(10, 0, 2, -12);

    //fire animation

    stroke(0);
    strokeWeight(3);
    fill(225, 90, 0);

    if ( fireChangeTimer >= 0 && fireChangeTimer < 30 ) {

      triangle( -45, 5, -35, -15, -25, 5);
      triangle( -50, 15, -40, -5, -30, 15 );
      triangle( -40, 20, -30, 0, -20, 20);

      triangle(50, 15, 35, -10, 20, 15);

      fireChangeTimer += 1;
    } else if ( fireChangeTimer >= 30 && fireChangeTimer < 60 ) {

      triangle( 45, 5, 35, -15, 25, 5);
      triangle( 50, 15, 40, -5, 30, 15 );
      triangle( 40, 20, 30, 0, 20, 20);

      triangle(-50, 15, -35, -10, -20, 15);
      fireChangeTimer += 1;
    } else {

      fireChangeTimer = 0;
    }



    popMatrix();
  }
}
