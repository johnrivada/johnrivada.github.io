ArrayList<Protein> proteinArray;
ArrayList<Button> buttonArray;
color[] colorArray = {
  color(64, 224, 208),
  color(0, 0, 255),
  color(0, 123, 0),
  color(255, 0, 0),
  color(255, 165, 0),
  color(0, 128, 128)
};

color[] highlightColorArray = {
  color(24, 184, 168),
  color(0, 0, 155),
  color(0, 53, 0),
  color(155, 0, 0),
  color(215, 125, 0),
  color(0, 88, 88)
};
int numProtein = 250;
boolean lightsOn = true;

int p1 = -1;
int p2 = -1;

boolean switchHover= false;

void setup() {
  size(540, 960);

  buttonArray = new ArrayList<Button>();

  for (int a = 0; a < 6; a++) {
    if (a != 5) {
      buttonArray.add(new Button(a, 10, 550+(a*60), colorArray[a], highlightColorArray[a], "Give fragment 1 to"));
    } else {
      buttonArray.add(new Button(a, 10, 550+(a*60), colorArray[a], highlightColorArray[a], ""));
    }
  }
  for (int a = 6; a < 12; a++) {
    buttonArray.add(new Button(a, 280, 550+(a*60)-360, colorArray[a-6], highlightColorArray[a-6], "Give fragment 2 to"));
  }


  proteinArray = new ArrayList<Protein>();
  float centerX = 270;
  float centerY = 270;
  float radius = 240;

  for (int a = 0; a < numProtein; a++) {
    while (true) {
      float x = random(centerX - radius, centerX + radius);
      float y = random(centerY - radius, centerY + radius);

      if (dist(x, y, centerX, centerY) <= radius) { // Check if the point is within the circle
        proteinArray.add(new Protein( x, y, (int)random(1, 7)));
        //proteinArray.add(new Protein( x, y, 1));
        break;
      }
    }
  }
}

void draw() {
  if (lightsOn) {
    background(255);
  } else {
    background(0);
  }

  if (lightsOn) {
    stroke(1);
  } else {
    stroke(255);
  }
  if (lightsOn) {
    fill(255);
    stroke(1);
  } else {
    fill(0);
    stroke(255);
  }
  ellipse(270, 270, 500,500);

  for (int a = 0; a < proteinArray.size(); a++) {
    for (int b = 0; b < proteinArray.size(); b++) {
      if ( a != b) {
        checkOverlap(a, b);
      }
    }
  }
  applyForces();
  for (int a = 0; a < proteinArray.size(); a++) {
    proteinArray.get(a).step();
  }
  for (int a = 0; a < proteinArray.size(); a++) {
    proteinArray.get(a).draw();
  }
  fluoresce();


  for (int a = 0; a < buttonArray.size(); a++) {
    if (mouseX  > buttonArray.get(a).x && mouseX < (buttonArray.get(a).x+buttonArray.get(a).bWidth)) {
      if (mouseY  > buttonArray.get(a).y && mouseY < (buttonArray.get(a).y+buttonArray.get(a).bHeight)) {
        buttonArray.get(a).hover = true;
      } else {
        buttonArray.get(a).hover = false;
      }
    } else {
      buttonArray.get(a).hover = false;
    }
  }
  if (mouseX  > 40 && mouseX < 230) {
    if (mouseY  > 850 && mouseY < 900) {
      switchHover = true;
    } else {
      switchHover=  false;
    }
  } else {
    switchHover = false;
  }

  for (int a = 0; a < buttonArray.size(); a++) {
    buttonArray.get(a).draw();
  }

  noFill();
  for (int a = 0; a < 6; a++) {
    if (a != 5) {
      ellipse(210, 575 + (a*60), 40,40);
    }
    ellipse(480, 575 + (a*60), 40,40);
  }

  textSize(30);
  fill(255);
  noStroke();


  text("u", 210, 575+10);
  text("u", 480, 575+10);

  triangle(210-12, 575+60+10+3, 210+12, 575+60+10+3, 210, 575+60+10-24);
  triangle(480-12, 575+60+10+3, 480+12, 575+60+10+3, 480, 575+60+10-24);

  rect(210-10, 575+120-10, 20, 20);
  rect(480-10, 575+120-10, 20, 20);

  ellipse(210, 575+180, 10,10);
  ellipse(480, 575+180, 10,10);

  pushMatrix();
  star(210, 575+240, 10, 16, 5);
  popMatrix();

  pushMatrix();
  star(480, 575+240, 10, 16, 5);
  popMatrix();

  if (lightsOn) {
    fill(255);
  } else {
    fill(0);
  }
  rect(10, 850, 270, 60);

  String tempText = "";
  if (lightsOn) {
    if (switchHover) {
      fill(color(125, 125, 125));
    } else {
      fill(255);
    }
    stroke(0);
    tempText = "Switch To Fluorescent Mode";
  } else {
    if (switchHover) {
      fill(color(125, 125, 125));
    } else {
      fill(255);
    }
    stroke(255);
    tempText = "Switch To Light Mode";
  }
  rect(40, 850, 190, 50);

  if (lightsOn) {
    fill(0);
  } else {
    fill(0);
  }
  textSize(15);
  text(tempText, 135, 850+30);
}

void mousePressed() {
  for (int a = 0; a < buttonArray.size(); a++) {
    if (mouseX  > buttonArray.get(a).x && mouseX < (buttonArray.get(a).x+buttonArray.get(a).bWidth)) {
      if (mouseY  > buttonArray.get(a).y && mouseY < (buttonArray.get(a).y+buttonArray.get(a).bHeight)) {
        if (a < 6) {
          for (int b = 0; b < 6; b++) {
            if (a != 5) {
              buttonArray.get(b).isClicked = false;
            }
          }
          if (a != 5) {
            buttonArray.get(a).clicked();
            p1 = a;
          }
        } else {
          for (int b = 6; b < 12; b++) {
            buttonArray.get(b).isClicked = false;
          }
          buttonArray.get(a).clicked();
          p2 = a;
        }
      }
    }
  }
  
  if (mouseX  > 40 && mouseX < 230) {
    if (mouseY  > 850 && mouseY < 900) {
      lightsOn = !lightsOn;
    } 
  } 
}


void mouseReleased() {
  for (int a = 0; a < buttonArray.size(); a++) {
    ///buttonList.get(a).clicked = false;
  }
}

void keyPressed() {
  if (key == ' ') {
    lightsOn = !lightsOn; // toggle the LightsOn variable
  }
}

void fluoresce() {
  for (int a = 0; a < proteinArray.size(); a++) {
    proteinArray.get(a).fluorescing = false;
  }


  if (p1 == 0) {
    if (p2 == 6 || p2 == 7 || p2 == 8 || p2 == 9 || p2 == 10 || p2 == 11) {
      for (int a = 0; a < proteinArray.size(); a++) {
        for (int b = 0; b < proteinArray.size(); b++) {
          if (proteinArray.get(a).type == (p1+1)) {
            if (proteinArray.get(b).type == (p2-5)) {
              if ( a != b) {
                if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
                  proteinArray.get(a).fluorescing = true;
                  proteinArray.get(b).fluorescing = true;
                }
              }
            }
          }
        }
        //if (proteinArray.get(a).type == (p1+1) || proteinArray.get(a).type == (p2-5)) {
        //  proteinArray.get(a).fluorescing = true;
        //}
      }
    }
  } else if (p1 == 1) {
    if (p2 == 6 || p2 == 8 || p2 == 9 || p2 == 11) {
      for (int a = 0; a < proteinArray.size(); a++) {
        for (int b = 0; b < proteinArray.size(); b++) {
          if (proteinArray.get(a).type == (p1+1)) {
            if (proteinArray.get(b).type == (p2-5)) {
              if ( a != b) {
                if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
                  proteinArray.get(a).fluorescing = true;
                  proteinArray.get(b).fluorescing = true;
                }
              }
            }
          }
        }
        //if (proteinArray.get(a).type == (p1+1) || proteinArray.get(a).type == (p2-5)) {
        //  proteinArray.get(a).fluorescing = true;
        //}
      }
    }
  } else if (p1 == 2) {
    if (p2 == 6 || p2 == 7 || p2 == 11) {
      for (int a = 0; a < proteinArray.size(); a++) {
        for (int b = 0; b < proteinArray.size(); b++) {
          if (proteinArray.get(a).type == (p1+1)) {
            if (proteinArray.get(b).type == (p2-5)) {
              if ( a != b) {
                if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
                  proteinArray.get(a).fluorescing = true;
                  proteinArray.get(b).fluorescing = true;
                }
              }
            }
          }
        }
        //if (proteinArray.get(a).type == (p1+1) || proteinArray.get(a).type == (p2-5)) {
        //  proteinArray.get(a).fluorescing = true;
        //}
      }
    }
  } else if (p1 == 3) {
    if (p2 == 6 || p2 == 7 || p2 == 9 || p2 == 11) {
      for (int a = 0; a < proteinArray.size(); a++) {
        for (int b = 0; b < proteinArray.size(); b++) {
          if (proteinArray.get(a).type == (p1+1)) {
            if (proteinArray.get(b).type == (p2-5)) {
              if ( a != b) {
                if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
                  proteinArray.get(a).fluorescing = true;
                  proteinArray.get(b).fluorescing = true;
                }
              }
            }
          }
        }
        //if (proteinArray.get(a).type == (p1+1) || proteinArray.get(a).type == (p2-5)) {
        //  proteinArray.get(a).fluorescing = true;
        //}
      }
    }
  } else if (p1 == 4) {
    //TODO ADD TRANSIENT INTERACTIONS
    if (p2 == 6 || p2 == 11) {
      for (int a = 0; a < proteinArray.size(); a++) {
        for (int b = 0; b < proteinArray.size(); b++) {
          if (proteinArray.get(a).type == (p1+1)) {
            if (proteinArray.get(b).type == (p2-5)) {
              if ( a != b) {
                if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
                  proteinArray.get(a).fluorescing = true;
                  proteinArray.get(b).fluorescing = true;
                }
              }
            }
          }
        }
        //if (proteinArray.get(a).type == (p1+1) || proteinArray.get(a).type == (p2-5)) {
        //  proteinArray.get(a).fluorescing = true;
        //}
      }
    }
  }
  if (p1 == 5) {
    //TODO MAKE RANDOM INTERACTION HERE
    if (p2 == 6 || p2 == 7 || p2 == 8 || p2 == 9 || p2 == 10 || p2 == 11) {
      for (int a = 0; a < proteinArray.size(); a++) {
        for (int b = 0; b < proteinArray.size(); b++) {
          if (proteinArray.get(a).type == (p1+1)) {
            if (proteinArray.get(b).type == (p2-5)) {
              if ( a != b) {
                if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
                  proteinArray.get(a).fluorescing = true;
                  proteinArray.get(b).fluorescing = true;
                }
              }
            }
          }
        }
        //if (proteinArray.get(a).type == (p1+1) || proteinArray.get(a).type == (p2-5)) {
        //  proteinArray.get(a).fluorescing = true;
        //}
      }
    }
  }
}

void applyForces() {
  float stickForce = 0.3;
  for (int a = 0; a < proteinArray.size(); a++) {
    for (int b = 0; b < proteinArray.size(); b++) {
      if (proteinArray.get(a).type == 1) { /////////////////////
        if ( a != b) {
          if (proteinArray.get(b).type == 1) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(0.01);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 2) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 3) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 4) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 5) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 6) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          }
        }
      } else if (proteinArray.get(a).type == 2) {  /////////////////////
        if ( a != b) {
          if (proteinArray.get(b).type == 1) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 2) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 3) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 4) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 5) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 6) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          }
        }
      } else if (proteinArray.get(a).type == 3) { /////////////////////
        if ( a != b) {
          if (proteinArray.get(b).type == 1) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);

              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 2) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 3) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 4) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 5) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 6) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          }
        }
      } else if (proteinArray.get(a).type == 4) { /////////////////////
        if ( a != b) {
          if (proteinArray.get(b).type == 1) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 2) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 3) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 4) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 5) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 6) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          }
        }
      } else if (proteinArray.get(a).type == 5) { /////////////////////
        if ( a != b) {
          if (proteinArray.get(b).type == 1) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 2) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 3) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 4) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 5) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 6) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          }
        }
      } else if (proteinArray.get(a).type == 6) { /////////////////////
        if ( a != b) {
          if (proteinArray.get(b).type == 1) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 2) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 3) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 4) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 5) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          } else if (proteinArray.get(b).type == 6) {
            if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, (proteinArray.get(a).size/2)+3, proteinArray.get(b).location.x, proteinArray.get(b).location.y, (proteinArray.get(b).size/2)+3)) {
              float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
              PVector t = new PVector(proteinArray.get(b).location.x - proteinArray.get(a).location.x, proteinArray.get(b).location.y - proteinArray.get(a).location.y);
              t.mult(stickForce);
              proteinArray.get(a).acceleration.add(t);
            }
          }
        }
      }
    }
  }
}


void checkOverlap(int a, int b) {
  if (circlesOverlap(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(a).size/2, proteinArray.get(b).location.x, proteinArray.get(b).location.y, proteinArray.get(b).size/2)) {
    float d = dist(proteinArray.get(a).location.x, proteinArray.get(a).location.y, proteinArray.get(b).location.x, proteinArray.get(b).location.y);
    PVector t = new PVector(proteinArray.get(a).location.x - proteinArray.get(b).location.x, proteinArray.get(a).location.y - proteinArray.get(b).location.y);
    t.mult(4);
    proteinArray.get(a).acceleration.add(t);
  }
}
////////////////////////////////////////////////////////////DONT TOUCH////////////////////////////////////////////////////////////
void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void arrow(float x1, float y1, float x2, float y2) {
  stroke(1);
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -3, -3);
  line(0, 0, 3, -3);
  stroke(0);
  popMatrix();
}

boolean circlesOverlap(float x1, float y1, float r1, float x2, float y2, float r2) {
  float distance = dist(x1, y1, x2, y2);
  return (distance <= r1 + r2);
}
