class Board {
  ArrayList<Card> topPlayer1;
  ArrayList<Card> topPlayer2;

  ArrayList<Card> bottomPlayer1;
  ArrayList<Card> bottomPlayer2;

  ArrayList<CardEquipment> equipmentSpaces;

  boolean waitingSelection = false;
  boolean selectedEquipment = false;
  boolean selectedHand = false;
  boolean selectedHero = false;

  Board() {
    topPlayer1 = new ArrayList<Card>();
    topPlayer2 = new ArrayList<Card>();
    bottomPlayer1  = new ArrayList<Card>();
    bottomPlayer2  = new ArrayList<Card>();

    equipmentSpaces = new ArrayList<CardEquipment>();

    for (int a = 0; a < 5; a++) {
      topPlayer1.add(null);
      topPlayer2.add(null);
      bottomPlayer1.add(null);
      bottomPlayer2.add(null);
    }

    for (int a = 0; a < 3; a++) {
      equipmentSpaces.add(null);
    }
  }

  void draw() {
    for (int a = 0; a < 5; a++) {
      for (int b = 0; b < 2; b++) {

        //topPlayer1
        fill(255);
        rect((a*130) + 10, 110, 120, 120);
        if (topPlayer1.get(a) != null) {
          fill(0);
          topPlayer1.get(a).displayImage((a*130) + 10, 110, 120, 120);
          fill(255);
        }

        //topPlayer2
        fill(255);
        rect((a*130) + 10, 240, 120, 120);
        if (topPlayer2.get(a) != null) {
          fill(0);
          topPlayer2.get(a).displayImage((a*130) + 10, 240, 120, 120);
          fill(255);
        }


        //bottomPlayer1
        if (waitingSelection) {
          if (selectedHand) {
            if (bottomPlayer1.get(a) == null) {
              fill(color(0, 255, 0));
            } else {
              fill(255);
            }
          }
        } else {
          fill(255);
        }

        rect((a*130) + 10, 640, 120, 120);
        if (bottomPlayer1.get(a) != null) {
          fill(0);
          bottomPlayer1.get(a).displayImage((a*130) + 10, 640, 120, 120);
          fill(255);
        }

        //bottomPlayer2
        fill(255);
        if (waitingSelection) {
          if (selectedEquipment) {
            if (bottomPlayer2.get(a) == null) {
              fill(color(0, 255, 0));
            } else {
              fill(255);
            }
          }
        } else {
          fill(255);
        }

        rect((a*130) + 10, 770, 120, 120);
        if (bottomPlayer2.get(a) != null) {
          fill(0);
          bottomPlayer2.get(a).displayImage((a*130) + 10, 770, 120, 120);
          fill(255);
        }

        fill(255);
      }
    }

    for (int a = 0; a < 5; a++ ) {
      if (mouseOver((a*130) + 10, 110, 120, 120)) {
        if (topPlayer1.get(a) != null) {
          highlightedCard = topPlayer1.get(a);
        }
      } else if (mouseOver((a*130) + 10, 240, 120, 120)) {
        if (topPlayer2.get(a) != null) {
          highlightedCard = topPlayer2.get(a);
        }
      } else if (mouseOver((a*130) + 10, 640, 120, 120)) {
        if (bottomPlayer1.get(a) != null) {
          highlightedCard = bottomPlayer1.get(a);
        }
      } else if (mouseOver((a*130) + 10, 770, 120, 120)) {
        if (bottomPlayer2.get(a) != null) {
          highlightedCard = bottomPlayer2.get(a);
        }
      }
    }

    for (int a = 0; a < 3; a++) {
      if (mouseOver((a*100)+135, 455, 90, 90)) {
        if (equipmentSpaces.get(a) != null) {
          highlightedCard = equipmentSpaces.get(a);
        }
      }
    }

    //accomplishment button
    rect(10, 455, 90, 90);
    fill(0);
    textSize(15);
    text("Accomplish", 10, 455, 90, 90);

    //draw pile
    fill(255);
    if (game.waitingDraw) {
      fill(color(0, 255, 0));
    }
    rect(460, 455, 90, 90);
    fill(0);

    text("Draw", 460, 455, 90, 70);
    text(deck.drawPile.size()+"", 460, 455, 90, 110);

    //discard pile
    fill(255);
    rect(560, 455, 90, 90);
    fill(0);
    text("Discard", 560, 455, 90, 70);
    text(deck.discardPile.size()+"", 560, 455, 90, 110);


    //equipment pile
    for (int a = 0; a < 3; a++) {
      fill(255);
      rect((a*100)+135, 455, 90, 90);
      fill(0);
      equipmentSpaces.get(a).displayImage((a*100)+135, 455, 90, 90);
    }
    textSize(11);
  }
}
