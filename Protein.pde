class Protein {
  PVector location;
  PVector velocity;
  PVector acceleration;

  int size = 20;
  int type = -1;
  boolean fluorescing = false;

  Protein(float ix, float iy, int it) {
    location = new PVector();
    location.x = ix;
    location.y = iy;

    velocity = new PVector();
    acceleration = new PVector();

    type = it;
  }

  void draw() {
    pushMatrix();
    // Draw the circle
    noStroke();
    if (lightsOn) {
      if (type == 1) {
        fill(64, 224, 208); //ubiquitin
      } else if (type == 2) {
        fill(0, 0, 255); //blue
      } else if (type == 3) {
        fill(0, 123, 0); //`
      } else if (type == 4) {
        fill(255, 0, 0); //red
      } else if (type == 5) {
        fill(255, 165, 0); //yellow
      } else if (type == 6) {
        fill(0, 128, 128); //investigatory
      } else {
        //fill(128, 128, 128);
      }
    } else {
      if (fluorescing) {
        fill(144, 238, 144);
        //if (type == 1) {
        //  fill(64, 224, 208); //ubiquitin
        //} else if (type == 2) {
        //  fill(0, 0, 255); //blue
        //} else if (type == 3) {
        //  fill(0, 123, 0); //
        //} else if (type == 4) {
        //  fill(255, 0, 0); //red
        //} else if (type == 5) {
        //  fill(255, 165, 0); //yellow
        //} else if (type == 6) {
        //  fill(0, 128, 128); //investigatory
        //} else {
        //  //fill(128, 128, 128);
        //}
      } else {
        fill(0);
      }
    }
    ellipse(location.x, location.y, size, size);

    if (lightsOn) {
      fill(255);
    } else {
      fill(0);
    }

    if (type == 1) {
      textAlign(LEFT);
      textSize(15);
      text("u", location.x-4, location.y+4);
    } else if (type == 2) {
      triangle(location.x-6, location.y+3, location.x+6, location.y+3, location.x, location.y-6);
    } else if (type == 3) {
      rect(location.x-5, location. y-5, 10, 10);
    } else if (type == 4) {
      ellipse(location.x, location.y, 10, 10);
    } else if (type == 5) {
      pushMatrix();
      star(location.x, location.y, 5, 8, 5);
      popMatrix();
    }

    //    PVector arrow = new PVector(0, 0);
    //    translate(location.x, location.y);
    //    arrow.add(velocity);
    //    arrow.mult(10);
    //    arrow(0, 0, arrow.x, arrow.y);

    popMatrix();
  }

  void step() {
    acceleration.x += random(-1, 1);
    acceleration.y += random(-1, 1);
    acceleration.setMag(0.05);

    velocity.add(acceleration);
    velocity.mult(0.98);

    float tempX = location.x + velocity.x;
    float tempY = location.y + velocity.y;

    if (dist(270, 270, tempX, tempY) > 239) {
      velocity.x = velocity.x * -1.3;
      velocity.y = velocity.y * -1.3;
      location.x += velocity.x;
      location.y += velocity.y;
    } else {
      location.x += velocity.x;
      location.y += velocity.y;
    }
  }
}
