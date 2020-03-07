class Player {
  float x;
  float y;

  float accY;
  float velY;
  float size;

  float velLimit = 10;

  int score = 0;
  boolean dead = false;

  Brain brain;

  Player() {
    x = 100;
    y = windowHeight/2;

    velY = 9;
    size = 50;

    brain = new Brain();
  }

  Player(Brain b) {
    x = 100;
    y = windowHeight/2;

    velY = 9;
    size = 50;

    brain = b;
  }

  void process() {
    accY += gravity;

    brain.compute();

    if (gameState != 1) {
      if (brain.matrixValues.get(brain.matrixValues.size()-1).get(0) > 0.9) {
        flap();
      }
    }

    velY += accY;

    if (velY > velLimit) {
      velY = velLimit;
    }

    if (velY < (velLimit*-1)) {
      velY = (velLimit*-1);
    }

    y += velY;

    if (y > (windowHeight-(size/2))) {
      y = (windowHeight-(size/2));
      velY = 0;
    } else if (y < 0) {
      y = 0;
      velY = 0;
    }

    accY = 0;
  }

  void draw() {
    fill(255, 255, 0);
    ellipse(x, y, size, size);
  }

  
  void flap() {
    accY -= 20;
  }
}
