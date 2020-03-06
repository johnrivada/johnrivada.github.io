float xSpeed = 3;
float gravity = 0.8;

boolean dead = true;

int windowHeight = 800;
int windowWidth = 400;

Player player;
PipePair pipe;

ArrayList<PipePair> pipes = new ArrayList<PipePair>();
int count = 0;

void newGame() {
  player = new Player(100, windowHeight/2);
  pipes.clear();
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
    }
    pipes.get(a).draw();
  }
  player.draw();
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
