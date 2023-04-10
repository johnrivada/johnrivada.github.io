char[] keys_to_check = { 'w', 'a', 's', 'd', 'z', 'x', 'i', 'k', 'l', 'f'};
boolean[] keys_down = new boolean[keys_to_check.length];

float j = 0.7;
float i = -0.85;
float k = -0.3;
float x = -220;
float yRotate = 0;
float xRotate = 0;
float zRotate = 0;
float rotationSpeed = 0.05;
boolean clicked = false;
boolean solute = false;
boolean lights = false;
boolean alreadyPressed = false;
boolean productCamera = true;


color unfilled = color(243, 255, 255, 128);
color filled = color(215, 255, 255, 128);
color green = color(170, 175, 85);
color cuvette = unfilled;

void setup() {
  size(800, 800, P3D);
  //lights();
  noStroke();
}

void draw() {
  background(255);
  controls();


  textSize(32);
  fill(0);
  text("Controls:", 10, 30);
  text("Camera: W,S,A,D & I,K", 10, 60);
  text("Add Solution: F", 10, 90);
  text("Move Cuvette: Z & X", 10, 120);
  text("Turn On Machine: L", 10, 150);
  text("Toggle Cuvette/Machine: Left Click", 10, 180);
  
  textSize(10);
  fill(255, 0, 0);
  text("red: x", 0, 739); 
  fill(0, 255, 0);
  text("green: y", 0, 747);
  fill(0, 0, 255);
  text("blue: z", 0, 755); 
  fill(0);
  text("i: " + i, 0, 763);
  text("j: " + j, 0, 771); 
  text("k: " + k, 0, 779);
  text("offset: " + x, 0, 787);
  text("productCamera:" + productCamera, 0, 795);

  translate(width>>1, height>>1);
  rotateY(j += yRotate);
  rotateX(i += xRotate);
  rotateZ(k += zRotate);


  noFill();
  stroke(255, 0, 0);
  beginShape();
  vertex(-200, 0, 0);
  vertex(200, 0, 0);
  vertex(200, 0, 10);
  endShape();

  stroke(0, 255, 0);
  beginShape();
  vertex(0, -200, 0);
  vertex(0, 200, 0);
  vertex(0, 200, 10);
  endShape();

  stroke(0, 0, 255);
  beginShape();
  vertex(0, 0, -200);
  vertex(0, 0, 200);
  vertex(10, 0, 200);
  endShape();

  if (productCamera) {
    stroke(0);

    float backCorners = -140;
    float topHeight = 10;
    float bottomHeight = -50;

    fill(green);
    beginShape();
    vertex(-100, bottomHeight, backCorners);
    vertex(100, bottomHeight, backCorners);
    vertex(100, topHeight, backCorners);
    vertex(-100, topHeight, backCorners);
    vertex(-100, bottomHeight, backCorners);
    endShape();
    noFill();

    fill(green);
    beginShape();
    vertex(-100, topHeight, backCorners);
    vertex(100, topHeight, backCorners);
    vertex(100, topHeight, 130);
    vertex(-100, topHeight, 130);
    vertex(-100, topHeight, backCorners);
    endShape();
    noFill();

    for (int f = 5; f < 25; f +=5) {
      beginShape();
      for (int a = 0; a <= 360; a+= 1) {
        float d = 10 * (sin(a))-50;
        float e = 10 * (cos(a))-20;
        vertex(d, e, backCorners+f);
      }
      endShape(CLOSE);

      beginShape();
      for (int a = 0; a <= 360; a+= 1) {
        float d = 10 * (sin(a))+0;
        float e = 10 * (cos(a))-20;
        vertex(d, e, backCorners+f);
      }
      endShape(CLOSE);

      beginShape();
      for (int a = 0; a <= 360; a+= 1) {
        float d = 10 * (sin(a))+50;
        float e = 10 * (cos(a))-20;
        vertex(d, e, backCorners+f);
      }
      endShape(CLOSE);
    }


    if (lights) {
      fill(255, 255, 0);

      beginShape();
      vertex(-55, -20, backCorners+25);
      vertex(-45, -20, backCorners+25);
      vertex(-45, -20, -5);
      vertex(-55, -20, -5);
      vertex(-55, -20, backCorners+25);
      endShape();

      beginShape();
      vertex(-5, -20, backCorners+25);
      vertex(5, -20, backCorners+25);
      vertex(5, -20, -5);
      vertex(-5, -20, -5);
      vertex(-5, -20, backCorners+25);
      endShape();

      beginShape();
      vertex(55, -20, backCorners+25);
      vertex(45, -20, backCorners+25);
      vertex(45, -20, -5);
      vertex(55, -20, -5);
      vertex(55, -20, backCorners+25);
      endShape();
      noFill();
    }

    fill(0);
    if (lights) {
      if (x > -144) {
        if (solute) {
          beginShape();
          vertex(-50, -20, -50);
          vertex(-49, -20, -50);
          vertex(-49, -20, -5);
          vertex(-50, -20, -5);
          vertex(-50, -20, -50);
          endShape();
        }
      }
    }
    noFill();

    fill(0);
    if (lights) {
      if (x > -94) {
        if (solute) {
          beginShape();
          vertex(0, -20, -50);
          vertex(1, -20, -50);
          vertex(1, -20, -5);
          vertex(0, -20, -5);
          vertex(0, -20, -50);
          endShape();
        }
      }
    }
    noFill();

    fill(0);
    if (lights) {
      if (x > -44) {
        if (solute) {
          beginShape();
          vertex(50, -20, -50);
          vertex(49, -20, -50);
          vertex(49, -20, -5);
          vertex(50, -20, -5);
          vertex(50, -20, -50);
          endShape();
        }
      }
    }

    noFill();

    beginShape();
    vertex(-100, bottomHeight, backCorners+25);
    vertex(100, bottomHeight, backCorners+25);
    vertex(100, topHeight, backCorners+25);
    vertex(-100, topHeight, backCorners+25);
    vertex(-100, bottomHeight, backCorners+25);
    endShape();

    beginShape();
    vertex(-100, bottomHeight, backCorners);
    vertex(100, bottomHeight, backCorners);
    vertex(100, bottomHeight, 100);
    vertex(-100, bottomHeight, 100);
    vertex(-100, bottomHeight, backCorners);
    endShape();

    fill(0);
    beginShape();
    vertex(-100, bottomHeight+1, 100);
    vertex(100, bottomHeight+1, 100);
    vertex(100, -19, 130);
    vertex(-100, -19, 130);
    vertex(-100, bottomHeight+1, 100);
    endShape();
    noFill();

    if (lights) {
      if (x > -44) {
        if (!solute) {
          fill(255, 0, 0);
        } else {
          fill(0);
        }
      } else {
        fill(0);
      }
    } else {
      fill(0);
    }

    beginShape();
    vertex(80, bottomHeight, 100);
    vertex(30, bottomHeight, 100);
    vertex(30, -20, 130);
    vertex(80, -20, 130);
    vertex(80, bottomHeight, 100);
    endShape();
    noFill();

    if (lights) {
      if (x > -44) {
        if (solute) {
          fill(0, 255, 0);
        } else {
          fill(0);
        }
      } else {
        fill(0);
      }
    } else {
      fill(0);
    }

    beginShape();
    vertex(20, bottomHeight, 100);
    vertex(20, bottomHeight, 100);
    vertex(20, -20, 130);
    vertex(-30, -20, 130);
    vertex(-30, bottomHeight, 100);
    endShape();
    noFill();

    if (lights) {
      if (x > -144) {
        fill(255, 255, 255);
      } else {
        fill(255, 255, 0);
      }
      beginShape();
      vertex(-80, bottomHeight, 100);
      vertex(-75, bottomHeight, 100);
      vertex(-75, -20, 130);
      vertex(-80, -20, 130);
      vertex(-80, bottomHeight, 100);
      endShape();
      noFill();

      if (x > -94) {
        fill(255, 255, 255);
      } else {
        fill(255, 255, 0);
      }
      beginShape();
      vertex(-73, bottomHeight, 100);
      vertex(-68, bottomHeight, 100);
      vertex(-68, -20, 130);
      vertex(-73, -20, 130);
      vertex(-73, bottomHeight, 100);
      endShape();
      noFill();

      if (x > -44) {
        fill(255, 255, 255);
      } else {
        fill(255, 255, 0);
      }
      beginShape();
      vertex(-66, bottomHeight, 100);
      vertex(-61, bottomHeight, 100);
      vertex(-61, -20, 130);
      vertex(-66, -20, 130);
      vertex(-66, bottomHeight, 100);
      endShape();
      noFill();
    }

    fill(green);
    beginShape();
    vertex(-100, -20, 130);
    vertex(100, -20, 130);
    vertex(100, topHeight, 130);
    vertex(-100, topHeight, 130);
    vertex(-100, -20, 130);
    endShape();
    noFill();

    fill(green);  
    beginShape();
    vertex(100, -20, 130);
    vertex(100, bottomHeight, 100);
    vertex(100, bottomHeight, backCorners);
    vertex(100, topHeight, backCorners);
    vertex(100, topHeight, 130);
    vertex(100, -20, 130);
    endShape();
    noFill();



    beginShape();
    vertex(-100, -20, 130);
    vertex(-100, bottomHeight, 100);
    vertex(-100, bottomHeight, backCorners);
    vertex(-100, topHeight, backCorners);
    vertex(-100, topHeight, 130);
    vertex(-100, -20, 130);
    endShape();


    beginShape();
    vertex(-100, bottomHeight+5, -40);
    vertex(-100, topHeight-5, -40);
    vertex(-100, topHeight-5, -100);
    vertex(-100, bottomHeight+5, -100);
    vertex(-100, bottomHeight+5, -40);
    endShape();


    beginShape();
    vertex(-100, bottomHeight, 0 );
    vertex(100, bottomHeight, 0 );
    vertex(100, topHeight, 0 );
    vertex(-100, topHeight, 0 );
    vertex(-100, bottomHeight, 0 );
    endShape();

    beginShape();
    for (int a = 0; a <= 360; a+= 1) {
      float d = 5 * (sin(a))-50;
      float e = 5 * (cos(a))-20;
      vertex(d, e, -10);
    }
    endShape(CLOSE);

    beginShape();
    for (int a = 0; a <= 360; a+= 1) {
      float d = 5 * (sin(a))+0;
      float e = 5 * (cos(a))-20;
      vertex(d, e, -10);
    }
    endShape(CLOSE);

    beginShape();
    for (int a = 0; a <= 360; a+= 1) {
      float d = 5 * (sin(a))+50;
      float e = 5 * (cos(a))-20;
      vertex(d, e, -10);
    }
    endShape(CLOSE);


    beginShape();
    for (int a = 0; a <= 360; a+= 1) {
      float d = 5 * (sin(a))-50;
      float e = 5 * (cos(a))-20;
      vertex(d, e, -5);
    }
    endShape(CLOSE);

    beginShape();
    for (int a = 0; a <= 360; a+= 1) {
      float d = 5 * (sin(a))+0;
      float e = 5 * (cos(a))-20;
      vertex(d, e, -5);
    }
    endShape(CLOSE);

    beginShape();
    for (int a = 0; a <= 360; a+= 1) {
      float d = 5 * (sin(a))+50;
      float e = 5 * (cos(a))-20;
      vertex(d, e, -5);
    }
    endShape(CLOSE);




    beginShape();
    vertex(-100, bottomHeight, -15 );
    vertex(100, bottomHeight, -15 );
    vertex(100, topHeight, -15 );
    vertex(-100, topHeight, -15 );
    vertex(-100, bottomHeight, -15 );
    endShape();

    /////////////////////////////////////////////////////////
    //stroke(255, 165, 0);
    fill(255, 165, 0, 128);
    beginShape();
    vertex(-100+x, bottomHeight+5, -40);
    vertex(-100+x, topHeight-5, -40);
    vertex(-100+x, topHeight-5, -100);
    vertex(-100+x, bottomHeight+5, -100);
    vertex(-100+x, bottomHeight+5, -40);
    endShape();

    noFill();


    stroke(0);

    fill(cuvette);
    beginShape();
    vertex(-99+x, topHeight-10, -50);
    vertex(-99+x, bottomHeight+10, -50);
    vertex(-99+x, bottomHeight+10, -90);
    vertex(-99+x, topHeight-10, -90);
    vertex(-99+x, topHeight-10, -50);
    endShape();

    beginShape();
    vertex(100+x, topHeight-10, -50);
    vertex(100+x, bottomHeight+10, -50);
    vertex(100+x, bottomHeight+10, -90);
    vertex(100+x, topHeight-10, -90);
    vertex(100+x, topHeight-10, -50);
    endShape();


    beginShape();
    vertex(100+x, bottomHeight+10, -50);
    vertex(-99+x, bottomHeight+10, -50);
    vertex(-99+x, bottomHeight+10, -90);
    vertex(100+x, bottomHeight+10, -90);
    vertex(100+x, bottomHeight+10, -50);
    endShape();

    beginShape();
    vertex(100+x, topHeight-10, -50);
    vertex(-99+x, topHeight-10, -50);
    vertex(-99+x, topHeight-10, -90);
    vertex(100+x, topHeight-10, -90);
    vertex(100+x, topHeight-10, -50);
    endShape();


    beginShape();
    vertex(100+x, topHeight-10, -90);
    vertex(-99+x, topHeight-10, -90);
    vertex(-99+x, bottomHeight+10, -90);
    vertex(100+x, bottomHeight+10, -90);
    vertex(100+x, topHeight-10, -90);
    endShape();

    beginShape();
    vertex(100+x, topHeight-10, -50);
    vertex(-99+x, topHeight-10, -50);
    vertex(-99+x, bottomHeight+10, -50);
    vertex(100+x, bottomHeight+10, -50);
    vertex(100+x, topHeight-10, -50);
    endShape();

    noFill();

    /////////////////////////////////////////////////////////
    beginShape();
    vertex(-90, topHeight, 10);
    vertex(90, topHeight, 10);
    vertex(90, topHeight, 100);
    vertex(-90, topHeight, 100);
    vertex(-90, topHeight, 10);
    endShape();

    beginShape();
    vertex(-90, topHeight-10, 10);
    vertex(90, topHeight-10, 10);
    vertex(90, topHeight-10, 100);
    vertex(-90, topHeight-10, 100);
    vertex(-90, topHeight-10, 10);
    endShape();

    beginShape();
    vertex(-90, topHeight, 10);
    vertex(-90, topHeight, 100);
    vertex(-90, topHeight-10, 100);
    vertex(-90, topHeight-10, 10);
    vertex(-90, topHeight, 10);
    endShape();

    beginShape();
    vertex(90, topHeight, 10);
    vertex(90, topHeight, 100);
    vertex(90, topHeight-10, 100);
    vertex(90, topHeight-10, 10);
    vertex(90, topHeight, 10);
    endShape();

    /////////////////////////////////////////////////////////
  } else {
    stroke(0);


    fill(255, 165, 0, 128);
    beginShape();
    vertex(-70, -181, -70);
    vertex(-70, -181, 70);
    vertex(70, -181, 70);
    vertex(70, -181, -70);
    vertex(-70, -181, -70);
    endShape();


    //fill(243, 255, 255, 128);
    fill(cuvette);
    beginShape();
    vertex(-50, 180, -50);
    vertex(-50, 180, 50);
    vertex(50, 180, 50);
    vertex(50, 180, -50);
    vertex(-50, 180, -50);
    endShape();

    beginShape();
    vertex(-50, 180, -50);
    vertex(-50, 180, 50);
    vertex(-50, -180, 50);
    vertex(-50, -180, -50);
    vertex(-50, 180, -50);
    endShape();

    beginShape();
    vertex(50, 180, -50);
    vertex(50, 180, 50);
    vertex(50, -180, 50);
    vertex(50, -180, -50);
    vertex(50, 180, -50);
    endShape();

    beginShape();
    vertex(-50, 180, -50);
    vertex(50, 180, -50);
    vertex(50, -180, -50);
    vertex(-50, -180, -50);
    vertex(-50, 180, -50);
    endShape();


    beginShape();
    vertex(-50, 180, 50);
    vertex(50, 180, 50);
    vertex(50, -180, 50);
    vertex(-50, -180, 50);
    vertex(-50, 180, 50);
    endShape();

    beginShape();
    vertex(-50, -180, -50);
    vertex(-50, -180, 50);
    vertex(50, -180, 50);
    vertex(50, -180, -50);
    vertex(-50, -180, -50);
    endShape();
    noFill();
  }
}



void mousePressed() {
  clicked = true;

  if (productCamera) {
    productCamera = false;
    i = 0;
    j = 0;
    k = 0;
  } else {
    productCamera = true;
    j = 0.7;
    i = -0.85;
    k = -0.3;
    x = -220;
  }
}

void mouseReleased() {
  clicked = false;
}

void keyPressed() {
  copeWithKeys(true); // TRUE MEANS KEY PRESSED
}

void keyReleased() {
  copeWithKeys(false); // FALSE MEANS KEY NOT PRESSED
  alreadyPressed = false;
}

void copeWithKeys(boolean state) {
  for ( int i = 0; i < keys_to_check.length; i++) {
    if ( keys_to_check[i] == key ) { 
      keys_down[i] = state;
    }
  }
}

void controls() {
  if (keys_down[0]) { //w
    xRotate = rotationSpeed;
  } else if (keys_down[2]) { //s
    xRotate = -rotationSpeed;
  } else {
    xRotate = 0;
  }


  if (keys_down[1]) { //a
    yRotate = -rotationSpeed;
  } else if (keys_down[3]) { //d 
    yRotate = rotationSpeed;
  } else {
    yRotate = 0;
  }

  if (keys_down[6]) { //i
    zRotate = -rotationSpeed;
  } else if (keys_down[7]) { //k 
    zRotate = rotationSpeed;
  } else {
    zRotate = 0;
  }

  if (keys_down[4]) { //z
    x-=1.2;
    if (x < -220) {
      x = -220;
    }
  } else if (keys_down[5]) { //x
    x+=1.2;
    if (x > 0) {
      x = 0;
    }
  }
  if (keys_down[8]) { //l
    if (!alreadyPressed) {
      alreadyPressed = true;
      if (lights) {
        lights = false;
      } else {
        lights = true;
      }
    }
  }

  if (keys_down[9]) { //f
    if (!alreadyPressed) {
      alreadyPressed = true;
      if (cuvette == filled) {
        cuvette = unfilled;
        solute = false;
      } else {
        cuvette = filled;
        solute = true;
      }
    }
  }
}