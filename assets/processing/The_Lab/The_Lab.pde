GameState game;

Player player;
Player foe;

Board board;

Deck deck;

Card nullCard;
CardEquipment nullEquipment;
Card highlightedCard;

Descriptions descriptions;

void setup() {
  size(1000, 1000);
  background(255);
  setupGame();
  newGame();
}

void draw() {
  background(255);
  textSize(11);
  fill(0);

  text(mouseX + " " + mouseY, 900, 20);
  //reset
  fill(255);
  rect(900, 965, 100, 25);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Reset Game", 900, 965, 100, 25);

  //end turn
  fill(255);
  rect(690, 940, 200, 50);
  fill(0);
  textSize(25);
  text("End Turn", 690, 940, 200, 50);
  textSize(11);

  board.draw();

  player.draw();
  foe.draw();

  //highlighted card
  fill(255);
  if (highlightedCard.type == "CardAction") {
    //fill(color(146, 32, 221));
  } else if (highlightedCard.type == "CardHero") {
    fill(color(255, 219, 89));
  } else if (highlightedCard.type == "CardEquipment") {
    fill(color(85, 107, 47));
  } else {
    fill(255);
  }
  rect(690, 290, 300, 420);

  highlightedCard.highlighted();

  player.drawSelected();

  game.draw();
}



void setupGame() {
  nullCard = new Card("null");
  nullEquipment = new CardEquipment("Empty", 999);
  descriptions = new Descriptions();
}

void newGame() {
  game = new GameState();
  player = new Player();
  foe = new Player(true);
  deck = new Deck();
  board = new Board();
  highlightedCard = nullCard;
  descriptions.init();


  for (int a = 0; a < 3; a++) {
    board.equipmentSpaces.set(a, deck.drawEquipmentCard());
  }

  for (int a = 0; a < 5; a++) {
    game.drawCard(player);
    game.drawCard(foe);
  }

  game.waitingDraw = true;
}


void mouseClicked() {
  if (game.waitingDraw) {
    if (deck.drawPile.size() == 0 ) {
      println("Draw pile empty");
    } else if (mouseOver(460, 455, 90, 90)) {
      game.drawCard(player);
      game.waitingDraw = false;
    }
  } else {
    if (board.waitingSelection) {
      if (board.selectedHand == true) {
        for (int a = 0; a < 5; a++) {
          if (mouseOver((a*130) + 10, 640, 120, 120)) {
            for (int b = 0; b < player.hand.size(); b++) {
              if (player.hand.get(b).clicked == true) {
                game.playHero(player, a, b);

                board.waitingSelection = false;
                board.selectedHand = false;
                board.selectedEquipment = false;
                board.selectedHero = false;

                game.currentHeroPlayed++;
              }
            }
          }
        }
      } else if (board.selectedEquipment == true) {
        for (int a = 0; a < 5; a++) {
          if (mouseOver((a*130) + 10, 770, 120, 120)) {
            for (int b = 0; b < 3; b++) {
              if (board.equipmentSpaces.get(b).clicked == true) {
                game.purchaseEquipment(player, a, b);

                board.waitingSelection = false;
                board.selectedHand = false;
                board.selectedHero = false;
                board.selectedEquipment = false;
              }
            }
          }
        }
      }

      for (int a = 0; a < player.hand.size(); a++) {
        player.hand.get(a).clicked = false;
      }
      board.waitingSelection = false;
      board.selectedHand = false;
      board.selectedEquipment = false;
      board.selectedHero = false;
    } else {
      //Since no previous selection was made, check to see if new selection was made
      player.checkClicks();
    }
  }

  //accomplishment button
  if (mouseOver(10, 455, 90, 90)) {
    game.accomplish(player);
  }

  //reset button
  if (mouseOver(900, 965, 100, 25)) {
    newGame();
  }

  //end turn
  if (mouseOver(690, 940, 200, 50)) {
    if (board.waitingSelection == false) {
      if (game.waitingDraw == false) {
        game.endTurnMaintenance(player);

        game.cpuTurn();
        game.currentHeroPlayed = 0;
      }
    }
  }
}

boolean mouseOver(int x, int y, int wid, int len) {
  println(x + " " + y + " " + wid + " " + len);
  if (mouseX > x) {
    if (mouseX < (x+wid)) {
      if (mouseY > y) {
        if ( mouseY < (y+len)) {
          return true;
        }
      }
    }
  }
  return false;
}


void keyPressed() {
  if (key == 'a') {
  } else if (keyCode == UP) {
  } else if (keyCode == DOWN) {
  } else if (keyCode == ENTER) {
  }
}
