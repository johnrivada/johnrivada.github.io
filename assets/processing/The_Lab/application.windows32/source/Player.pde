class Player {
  String name = " ";
  int health = -1;
  boolean isCPU = false;

  int drawHandOffsetX = -1;
  int drawHandOffsetY = -1;

  int drawPointsOffsetX = -1;
  int drawPointsOffsetY = -1;

  ArrayList<Card> hand = new ArrayList<Card>();

  boolean alreadyClicked = false;

  int productivityPointsCurrent = -1;
  int accomplishmentPoints = -1;

  Player() {
    name = "Player";
    hand = new ArrayList<Card>();  

    productivityPointsCurrent = 0;
    accomplishmentPoints = 0;

    drawHandOffsetX = 10;
    drawHandOffsetY = 940;

    drawPointsOffsetX = 10;
    drawPointsOffsetY = 567;
  }

  Player(boolean cpu) {
    isCPU = cpu;
    name = "CPU";
    hand = new ArrayList<Card>();

    productivityPointsCurrent = 0;
    accomplishmentPoints = 0;

    drawHandOffsetX = 10;
    drawHandOffsetY = 10;

    drawPointsOffsetX = 10;
    drawPointsOffsetY = 382;
  }

  void draw() {
    drawHand();
    //if (name != "CPU") {
    for (int a = 0; a <  hand.size(); a++ ) {
      if (mouseOver((a*60) + drawHandOffsetX, drawHandOffsetY, 50, 50)) {
        highlightedCard = hand.get(a);
      }
    }
    //}

    fill(255);
    rect(drawPointsOffsetX, drawPointsOffsetY, 250, 50);
    rect(drawPointsOffsetX+390, drawPointsOffsetY, 250, 50);
    fill(0);
    textSize(15);
    text("Productivity Points: " + productivityPointsCurrent, drawPointsOffsetX, drawPointsOffsetY, 250, 50);
    text("Accomplishment Points: " + accomplishmentPoints, drawPointsOffsetX+390, drawPointsOffsetY, 250, 50);
    textSize(11);
  }

  void drawCard() {
    hand.add(deck.drawCard());
  }

  void drawHand() {
    for (int a = 0; a <  hand.size(); a++ ) {
      if (name != "CPU") {
        rect((a*60) + drawHandOffsetX, drawHandOffsetY, 50, 50);
        hand.get(a).displayImage((a*60) + drawHandOffsetX, drawHandOffsetY, 50, 50);
      } else {
        fill(color(255, 255, 20));
        rect((a*60) + drawHandOffsetX, drawHandOffsetY, 50, 50);
        fill(0);
      }
    }
  }

  void drawSelected() {
    for (int a = 0; a < hand.size(); a++) {
      if (hand.get(a).clicked == true) {     
        hand.get(a).selected();
      } else if (hand.get(a).clickedAction == true) {
        hand.get(a).selectedAction();
      }
    }

    for (int a = 0; a < 5; a++) {
      if (board.bottomPlayer1.get(a) != null) {
        if (board.bottomPlayer1.get(a).clickedAbility == true) {
          board.bottomPlayer1.get(a).selectedAbility();
        }
      }
    }
  }

  void checkClicks() {
    alreadyClicked = false;

    //clicked on hand
    for (int a = 0; a < hand.size(); a++) {
      //cllicked on hero card
      if (hand.get(a).clicked) {
        if (mouseOver(hand.get(a).clickedX, hand.get(a).clickedY, 100, 20)) {
          board.waitingSelection = true;
          board.selectedHand = true;
          alreadyClicked = true;
        }
      //clicked on action card
      } else if (hand.get(a).clickedAction) {
        if (mouseOver(hand.get(a).clickedX, hand.get(a).clickedY, 100, 20)) {
          game.playAction(this, a);
        }
        alreadyClicked = true;
      }
    }

    //clicked on equipment
    for (int a = 0; a < 3; a++) {
      if (mouseOver((a*100)+135, 455, 90, 90)) {
        
        if (player.productivityPointsCurrent >= board.equipmentSpaces.get(a).requiredProductivity) {
          int totalStrength = game.getStrength(this);
          if (totalStrength > board.equipmentSpaces.get(a).requiredStrength) {
            board.waitingSelection = true; 
            board.selectedEquipment = true; 
            board.equipmentSpaces.get(a).clicked(); 
            alreadyClicked = true;
          } else {
            game.changeCurrentText("Not enough strength.");
          }
        } else {
          game.changeCurrentText("Not enough productivity points.");
        }
      }
    }
    
    //clicked on hero ability
    for (int a = 0; a < 5; a++) {
      if (board.bottomPlayer1.get(a) != null) {
        if (board.bottomPlayer1.get(a).clickedAbility) {
          if (mouseOver(board.bottomPlayer1.get(a).clickedX, board.bottomPlayer1.get(a).clickedY, 100, 20)) {
            game.activateAbility(this, a);
            alreadyClicked = true;
          }
        }
      }
    }

    for (int a = 0; a < 5; a++) {
      if (board.bottomPlayer1.get(a) != null) {
        board.bottomPlayer1.get(a).unclicked();
      }
    }

    for (int a = 0; a < hand.size(); a++) {
      if (hand.get(a).type == "CardAction") {
        hand.get(a).unclicked();
      }
    }


    if (alreadyClicked == false) {
      for (int a = 0; a < hand.size(); a++) {
        hand.get(a).unclicked();
      }
      for (int a = 0; a < 3; a++) {
        board.equipmentSpaces.get(a).unclicked();
      }


      for (int a = 0; a < hand.size(); a++) {
        if (mouseOver((a*60) + drawHandOffsetX, drawHandOffsetY, 50, 50)) {
          if (hand.get(a).type == "CardHero") {
            if (game.currentHeroPlayed >= game.playerPlayHeroLimit) {
              game.changeCurrentText("Max amount of members played");
            } else {
              hand.get(a).clicked();
            }
          } else if (hand.get(a).type == "CardAction") {
            hand.get(a).clickedAction();
          }
        }
      }

      for (int a = 0; a < 5; a++) {
        if (board.bottomPlayer1.get(a) != null) {
          if (mouseOver((a*130) + 10, 640, 120, 120)) {
            if (board.bottomPlayer1.get(a).usedAbility == true) {
              game.changeCurrentText("Ability already used");
            } else {
              board.bottomPlayer1.get(a).clickedAbility();
            }
          }
        }
      }
    }
  }
}
