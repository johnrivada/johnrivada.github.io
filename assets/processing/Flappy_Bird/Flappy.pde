float xSpeed = 3;
float gravity = 0.8;

int windowHeight = 800;
int windowWidth = 400;

int brainWindowSize = 200;
Player player;
PipePair pipe;

ArrayList<PipePair> pipes = new ArrayList<PipePair>();
int count = 99;

int score = 0;

int highestScore = 0;

ArrayList<Player> playerPopulation = new ArrayList<Player>();
ArrayList<Player> nextGeneration;
int playerNum = 100;
int playerIndex = 0;
int playerGenIndex = 0;


float mutationRate = 0.25;
int numDead = 0;

int gameState = 0;
int playerContoller = 0;

boolean topSelected = false;
boolean bottomSelected = false;

int kSelection = -1;

boolean dead = false;
int deadFrame = 0; 

int numTries = 0;
void setup() {
  size(450, 800);
  setupSigmoid();
  setupGeneration();
}

void draw() {
  background(135, 206, 250);
  if (gameState == 0) {
    if (mouseX > 125 && mouseX < 325) {
      if (mouseY > 300 && mouseY < 350) {
        topSelected = true;
      } else if (mouseY > 500 && mouseY < 550) {
        bottomSelected = true;
      } else {
        topSelected = false;
        bottomSelected = false;
      }
    } else {
      topSelected = false;
      bottomSelected = false;
    }

    if (topSelected) {
      fill(200);
    } else {
      fill(255);
    }

    if (kSelection == 0) {
      strokeWeight(3);
    } else {
      strokeWeight(0);
    }
    rect(125, 300, 200, 50);

    if (bottomSelected) {
      fill(200);
    } else {
      fill(255);
    }
    if (kSelection == 1) {
      strokeWeight(3);
    } else {
      strokeWeight(0);
    }

    rect(125, 500, 200, 50);

    strokeWeight(1);

    fill(0);
    textSize(24);
    textAlign(CENTER);
    text("Player Controlled", 225, 335);
    text("AI  Controlled", 225, 535);
  } else {
    if (count % 100 == 0) {
      pipes.add(new PipePair());
    }

    getInput();

    if (!dead) {
      for (int a = 0; a < pipes.size(); a++) {
        pipes.get(a).process();
      }
    }

    if (gameState == 1) {
      if (!dead) {
        player.process();
      } else {
        deadFrame++;
      }
    } else if (gameState == 3) {
      player.process();
    } else if (gameState == 2) {
      for (int b = 0; b < playerPopulation.size(); b++) {
        if (playerPopulation.get(b).dead == false) {
          playerPopulation.get(b).process();
        }
      }
    }

    for (int a = 0; a < pipes.size(); a++) {
      if (gameState == 1) {
        if (pipes.get(a).topPipe.collided(player) || pipes.get(a).bottomPipe.collided(player)) {
          if (score > highestScore) {
             highestScore = score;
          }
          dead = true;
        }
      } else if (gameState == 3) {
        if (pipes.get(a).topPipe.collided(player) || pipes.get(a).bottomPipe.collided(player)) {
          player.dead = true;
          player.score = score;
        }
      } else if (gameState == 2) {
        for (int b = 0; b < playerPopulation.size(); b++) {
          if (playerPopulation.get(b).dead == false) {
            if (pipes.get(a).topPipe.collided(playerPopulation.get(b)) || pipes.get(a).bottomPipe.collided(playerPopulation.get(b))) {
              playerPopulation.get(b).dead = true;
              playerPopulation.get(b).score = score;
            }
          }
        }
      }

      if (pipes.get(a).bottomPipe.x < (0-pipes.get(a).bottomPipe.width)) {
        pipes.remove(a);
        score++;
      }

      pipes.get(a).draw();
    }
    if (gameState == 1) {
      player.draw();
    } else if (gameState == 3) {
      player.draw();
      player.brain.draw();
    } else if (gameState == 2) {
      for (int b = 0; b < playerPopulation.size(); b++) {
        if (playerPopulation.get(b).dead == false) {
          playerPopulation.get(b).draw();
        }
      }

      Player playerBrain = new Player();
      for (int a = 0; a < playerPopulation.size(); a++) {
        if (playerPopulation.get(a).dead == false) {
          playerBrain = playerPopulation.get(a);
          break;
        }
      }
      playerBrain.brain.draw();
    } 

    //drawArrows();

    textSize(48);
    fill(0);
    textAlign(LEFT);
    text(score, windowWidth/2, windowHeight/2-300);
    textSize(12);
    count++;

    if (gameState == 2) {
      text("pgi: " + playerGenIndex, 0, 515);

      numDead = 0;
      for (int a = 0; a < playerPopulation.size(); a++) {
        if (playerPopulation.get(a).dead == true) {
          numDead++;
        }
      }
      text("numDead: " + numDead, 0, 530);
      if (numDead == playerNum) {
        newGame();
      }
    } else if (gameState == 3) {
      text("pi: " + playerIndex, 0, 500);
      text("pgi: " + playerGenIndex, 0, 515);
      if (player.dead == true) {
        newGame();
      }
    }
    text("highestScore: " + highestScore, 0, 545);
  }
  if(gameState == 1) {
    text("tries: " + numTries, 0, 530);
  }
  if (deadFrame > 100) {
    textSize(40);
    textAlign(CENTER);
    text("SPACE/CLICK/TAP TO", windowWidth/2 + 20, windowHeight/2);
    text("TO RESPAWN", windowWidth/2 + 20, windowHeight/2 + 50);
  }
}

void keyPressed() {
  if (gameState == 0) {
    if (key == 'a') {
      playerNum = 10;
      gameState = 3;
      newGame();
    } else if (keyCode == UP) {
      if (kSelection == 0) {
        kSelection = 1;
      } else {
        kSelection = 0;
      }
    } else if (keyCode == DOWN) {
      if (kSelection == 1) {
        kSelection = 0;
      } else {
        kSelection = 1;
      }
    } else if (keyCode == ENTER) {
      if (kSelection == 0) {
        gameState = 1;
        newGame();
      } else {
        gameState = 2;
        newGame();
      }
    }
  }

  if (key == 'b') {
    gameState = 0;
    playerNum = 100;
  }



  if (!dead) {
    if (gameState == 1) {
      player.flap();
    }
  } else if (deadFrame > 100) {
    deadFrame = 0;
    dead = false;
    newGame();
  }
}

void mousePressed() {

  if (!dead) {
    if (gameState == 1) {
      player.flap();
    }
  } else if (deadFrame > 100) {
    deadFrame = 0;
    dead = false;
    newGame();
  }
}

void mouseReleased() {
  if (gameState == 0) {
    if (mouseX > 125 && mouseX < 325) {
      if (mouseY > 300 && mouseY < 350) {
        gameState = 1;
        newGame();
      } else if (mouseY > 500 && mouseY < 550) {
        gameState = 2;
        newGame();
      }
    }
  }
}
void drawArrows() {
  //if (pipes.size() > 0) {
  //  line(player.x, player.y, pipes.get(0).bottomPipe.x, pipes.get(0).bottomPipe.topY);
  //  line(player.x, player.y, pipes.get(0).bottomPipe.x, pipes.get(0).topPipe.bottomY);
  //}
  for (int b = 0; b < playerPopulation.size(); b++) {
    if (pipes.size() > 0) {
      if (playerPopulation.get(b).dead == false) {
        line(playerPopulation.get(b).x, playerPopulation.get(b).y, pipes.get(0).bottomPipe.x, pipes.get(0).bottomPipe.topY);
        line(playerPopulation.get(b).x, playerPopulation.get(b).y, pipes.get(0).bottomPipe.x, pipes.get(0).topPipe.bottomY);
      }
    }
  }
}

void getInput() {
  if (pipes.size() > 0) {
    //player.brain.matrixValues.get(0).set(0, (pipes.get(0).bottomPipe.x-player.x-(player.size/2)));
    //player.brain.matrixValues.get(0).set(1, (pipes.get(0).topPipe.bottomY-player.y+(player.size/2)));
    //player.brain.matrixValues.get(0).set(2, (pipes.get(0).bottomPipe.topY-player.y-(player.size/2)));
    for (int b = 0; b < playerPopulation.size(); b++) {
      if (playerPopulation.get(b).dead == false) {
        playerPopulation.get(b).brain.matrixValues.get(0).set(0, (pipes.get(0).bottomPipe.x-playerPopulation.get(b).x-(playerPopulation.get(b).size/2)));
        playerPopulation.get(b).brain.matrixValues.get(0).set(1, (pipes.get(0).topPipe.bottomY-playerPopulation.get(b).y+(playerPopulation.get(b).size/2)));
        playerPopulation.get(b).brain.matrixValues.get(0).set(2, (pipes.get(0).bottomPipe.topY-playerPopulation.get(b).y-(playerPopulation.get(b).size/2)));
        playerPopulation.get(b).brain.matrixValues.get(0).set(3, playerPopulation.get(b).velY);
      }
    }
  }
}

void newGame() {
  score = 0;
  count = 0;
  dead = false;
  numTries++;
  
  
  if (gameState == 1) {
    player = new Player();
  } else if (gameState == 3) {
    playerIndex++;
    if (playerIndex >= playerNum) {
      playerIndex = 0;
      playerGenIndex++;
      createGeneration();
    }
    player = playerPopulation.get(playerIndex);
  } else if (gameState == 2) {
    playerGenIndex++;
    createGeneration();
    for (int a = 0; a < playerPopulation.size(); a++) {
      if (playerPopulation.get(a).score > highestScore) {
        highestScore = playerPopulation.get(a).score;
      }
    }
  }

  pipes.clear();
}


void setupGeneration() {
  for (int sIndex = 0; sIndex < playerNum; sIndex++) {
    playerPopulation.add(new Player());
  }
}


void createGeneration() {
  nextGeneration = new ArrayList<Player>();
  for (int nsgIndex = 0; nsgIndex < playerNum * 0.1; nsgIndex++) {
    int ssHighest = 0;
    int ssIndex = 0;
    for (int spIndex = 0; spIndex < playerPopulation.size(); spIndex++) {
      if (playerPopulation.get(spIndex).score > ssHighest) {
        ssHighest = playerPopulation.get(spIndex).score;
        ssIndex = spIndex;
      }
    }

    nextGeneration.add(playerPopulation.get(ssIndex));
    playerPopulation.remove(ssIndex);
  }

  playerPopulation = new ArrayList<Player>();

  for (int sIndex = 0; sIndex < playerNum; sIndex++) {
    int parentA = int(random(0, nextGeneration.size()));
    int parentB = int(random(0, nextGeneration.size()));

    Brain tempBrain = new Brain();
    float randomNumber = 0;
    float randomMutation = 0;
    float modifier = 1;

    for (int lIndex = 0; lIndex < tempBrain.matrixValues.size(); lIndex++) {
      for (int lnIndex = 0; lnIndex < tempBrain.matrixValues.get(lIndex).size(); lnIndex++) {
        randomNumber = random (0, 100);
        randomMutation = random(0, 1);
        if (randomMutation < mutationRate) {
          modifier = 1+ random(-3, 3);
        } else {
          modifier = 1;
        }
        if (randomNumber > 50) {
          tempBrain.matrixValues.get(lIndex).set(lnIndex, nextGeneration.get(parentA).brain.matrixValues.get(lIndex).get(lnIndex) * modifier);
        } else {
          tempBrain.matrixValues.get(lIndex).set(lnIndex, nextGeneration.get(parentB).brain.matrixValues.get(lIndex).get(lnIndex)  * modifier);
        }
      }
    }

    for (int lIndex = 0; lIndex < tempBrain.matrixWeights.size(); lIndex++) {
      for (int lnIndex = 0; lnIndex < tempBrain.matrixWeights.get(lIndex).size(); lnIndex++) {
        for (int plnIndex =0; plnIndex < tempBrain.matrixWeights.get(lIndex).get(lnIndex).size(); plnIndex++) {
          randomNumber = random (0, 100);
          randomMutation = random(0, 1);
          if (randomMutation < mutationRate) {
            modifier = 1+ random(-1, 1.1);
          } else {
            modifier = 1;
          }

          if (randomNumber > 50) {
            tempBrain.matrixWeights.get(lIndex).get(lnIndex).set(plnIndex, nextGeneration.get(parentA).brain.matrixWeights.get(lIndex).get(lnIndex).get(plnIndex) * modifier);
          } else {
            tempBrain.matrixWeights.get(lIndex).get(lnIndex).set(plnIndex, nextGeneration.get(parentB).brain.matrixWeights.get(lIndex).get(lnIndex).get(plnIndex) * modifier);
          }
        }
      }
    }

    for (int lIndex = 0; lIndex < tempBrain.matrixBias.size(); lIndex++) {
      for (int lnIndex = 0; lnIndex < tempBrain.matrixBias.get(lIndex).size(); lnIndex++) {
        randomNumber = random (0, 100);
        randomMutation = random(0, 1);
        if (randomMutation < mutationRate) {
          modifier = 1+ random(-1, 1.1);
        } else {
          modifier = 1;
        }
        if (randomNumber > 50) {
          tempBrain.matrixBias.get(lIndex).set(lnIndex, nextGeneration.get(parentA).brain.matrixBias.get(lIndex).get(lnIndex) * modifier);
        } else {
          tempBrain.matrixBias.get(lIndex).set(lnIndex, nextGeneration.get(parentB).brain.matrixBias.get(lIndex).get(lnIndex) * modifier);
        }
      }
    }
    playerPopulation.add(new Player(tempBrain));
  }
}
