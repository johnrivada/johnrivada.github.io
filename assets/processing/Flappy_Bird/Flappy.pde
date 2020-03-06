float xSpeed = 3;
float gravity = 0.8;

boolean dead = true;

int windowHeight = 800;
int windowWidth = 400;

int brainWindowSize = 200;
Player player;
PipePair pipe;

ArrayList<PipePair> pipes = new ArrayList<PipePair>();
int count = 0;

int score = 0;


Brain brain = new Brain();

void newGame() {
  player = new Player(100, windowHeight/2);
  pipes.clear();
  score = 0;
}

void setup() {
  size(450, 800);
  newGame();
}

void draw() {
  background(135, 206, 250);

  if (count % 100 == 0) {
    pipes.add(new PipePair());
  }

  if (!dead) {
    for (int a = 0; a < pipes.size(); a++) {
      pipes.get(a).process();
    }
    player.process();
  }

  for (int a = 0; a < pipes.size(); a++) {
    if (pipes.get(a).topPipe.collided(player) || pipes.get(a).bottomPipe.collided(player)) {
      dead = true;
    }

    if (pipes.get(a).bottomPipe.x < (0-pipes.get(a).bottomPipe.width)) {
      pipes.remove(a);
      score++;
    }
    pipes.get(a).draw();
  }
  player.draw();

  drawArrows();

  getInput();
  brain.compute();
  brain.draw();

  textSize(12);
  fill(0);
  textAlign(LEFT);
  text(score, windowWidth/2, windowHeight/2-300);
  //if (pipes.size() > 0) {
  //  text("X Distance:" + (pipes.get(0).bottomPipe.x-player.x-(player.size/2)), 0, 700);
  //  text("Y Distance to top: " + (pipes.get(0).topPipe.bottomY-player.y+(player.size/2)), 0, 725);
  //  text("Y Distance to bottom: " + (pipes.get(0).bottomPipe.topY-player.y-(player.size/2)), 0, 750);
  //}
  count++;
}

void keyPressed() {
  if (dead) {
    dead = false;
    newGame();
  }
  player.flap();
}

void mousePressed() {
  if (dead) {
    dead = false;
    newGame();
  }
  player.flap();
}

void drawArrows() {
  if (pipes.size() > 0) {
    line(player.x, player.y, pipes.get(0).bottomPipe.x, pipes.get(0).bottomPipe.topY);
    line(player.x, player.y, pipes.get(0).bottomPipe.x, pipes.get(0).topPipe.bottomY);
  }
}

void getInput() {
  if (pipes.size() > 0) {
    brain.matrixValues.get(0).set(0, (pipes.get(0).bottomPipe.x-player.x-(player.size/2)));
    brain.matrixValues.get(0).set(1, (pipes.get(0).topPipe.bottomY-player.y+(player.size/2)));
    brain.matrixValues.get(0).set(2, (pipes.get(0).bottomPipe.topY-player.y-(player.size/2)));
  }
}
