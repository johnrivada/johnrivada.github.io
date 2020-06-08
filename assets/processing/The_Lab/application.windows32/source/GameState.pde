class GameState {
  String currentPlayer;

  boolean waitingDraw = false;

  int playerPlayHeroLimit = 1;
  int foePlayHeroLimit = 1;

  Player jeffPlayer = null;
  int currentHeroPlayed = 0;
  boolean jeffConference = false;
  int jeffConferenceDays = 0;


  ArrayList<String> textNotif = new ArrayList<String>();

  GameState() {
    for (int a = 0; a < 10; a++) {
      textNotif.add(".");
    }
  }

  void draw() {
    textAlign(CENTER);
    //text("Player: " + turnPlayer.name, 600, 590);

    //current Text
    fill(255);
    rect(690, 730, 300, 200);
    if (waitingDraw) {
      changeCurrentText("Draw a card");
    } else if (board.waitingSelection == true) {
      changeCurrentText("Select space to play");
    } else {
      changeCurrentText("End turn when finished");
    }
    fill(0);
    textSize(15);
    for (int a = 0; a < 10; a++) {
      text(textNotif.get(a), 690, (20*a)+730, 300, 20);
    }
    fill(255);
    textSize(11);

    textAlign(LEFT);
  }

  void changeCurrentText(String str) {
    if (str != textNotif.get(textNotif.size()-1)) {
      textNotif.add(str);
      if (textNotif.size() > 9) {
        textNotif.remove(0);
      }
    }
  }


  void resetAbilities(Player lPlayer) {
    ArrayList<Card> heroRow = new ArrayList<Card>();

    if (lPlayer == player) {
      heroRow = board.bottomPlayer1;
    } else if (lPlayer == foe) {
      heroRow = board.topPlayer2;
    }


    for (int a = 0; a < 5; a++) {
      if (heroRow.get(a) != null) {
        heroRow.get(a).usedAbility = false;
        if (heroRow.get(a).name != "JeffS") {
          heroRow.get(a).usedAbility = false;
        }
      }
    }
  }

  void drawCard(Player lPlayer) {
    if (deck.drawPile.size() > 0) {
      if (lPlayer.hand.size() <= 10) {
        lPlayer.drawCard();
        if (deck.drawPile.size() == 0) {
          if (deck.discardPile.size() > 0) {
            for (int a = 0; a < deck.discardPile.size(); a++) {
              for (int b = 0; b < deck.drawList.size(); b++) {
                if (deck.drawList.get(b).name == deck.discardPile.get(a).name) {
                  if (deck.drawList.get(b).type == "CardHero") {
                    if (deck.drawList.get(b). name != "Ben") {
                      deck.drawList.get(b).health = (int)random(5)+1;
                    }
                  }
                  deck.drawPile.add(deck.drawList.get(b));
                }
              }
            }
            deck.discardPile = new ArrayList<Card>();
          }
        }
      }
    }
  }


  void endTurnMaintenance(Player lPlayer) {
    ArrayList<Card> heroRow = new ArrayList<Card>();
    ArrayList<Card> equipmentRow = new ArrayList<Card>();

    if (lPlayer == player) {
      heroRow = board.bottomPlayer1;
      equipmentRow = board.bottomPlayer2;
    } else if (lPlayer == foe) {
      heroRow = board.topPlayer2;
      equipmentRow = board.topPlayer1;
    }

    //check if smith is at conference
    if (lPlayer == jeffPlayer) {
      if (jeffConference == true) {
        jeffConferenceDays++;
        if (jeffConferenceDays == 3) {
          jeffPlayer.productivityPointsCurrent += 10;
          for (int a = 0; a < 5; a++) {
            if (heroRow.get(a) != null) {
              if (heroRow.get(a).name == "JeffS") {
                heroRow.get(a).nickname = "Jefe";
                heroRow.get(a).productivity = 2;
                heroRow.get(a).strength = 3;
                heroRow.get(a).health = 5;
                heroRow.get(a).usedAbility = false;
              }
            }
          }
          jeffConferenceDays = 0;
          jeffConference = false;
          jeffPlayer = null;
        }
      }
    }

    //add productivity poitns and effects
    for (int a = 0; a < 5; a++) {
      if (heroRow.get(a) != null) {
        lPlayer.productivityPointsCurrent += heroRow.get(a).productivity;
      }
    }

    for (int a = 0; a < 5; a++) {
      if (equipmentRow.get(a) != null) {
        if (equipmentRow.get(a).name == "MS") {
          for (int b = 0; b < 5; b++) {
            if (heroRow.get(b) != null) {
              if (heroRow.get(b).name == "Karl" || heroRow.get(b).name == "Josh" || heroRow.get(b).name == "Christian") {
                lPlayer.productivityPointsCurrent += 3;
                break;
              }
            }
          }
        } else if (equipmentRow.get(a).name == "NMR") {
          for (int b = 0; b < 5; b++) {
            if (heroRow.get(b) != null) {
              if (heroRow.get(b).name == "John" || heroRow.get(b).name == "Chelsey" || heroRow.get(b).name == "Sam") {
                lPlayer.productivityPointsCurrent += 3;
                break;
              }
            }
          }
        } else if (equipmentRow.get(a).name == "Bubbler") {
          for (int b = 0; b < 5; b++) {
            if (heroRow.get(b) != null) {
              if (heroRow.get(b).name == "Ben" || heroRow.get(b).name == "Malaika" || heroRow.get(b).name == "Wondu") {
                lPlayer.productivityPointsCurrent += 3;
                break;
              }
            }
          }
        } else if (equipmentRow.get(a).name == "Radio") {
          lPlayer.productivityPointsCurrent +=1;
        } else if (equipmentRow.get(a).name == "DZM") {
          lPlayer.productivityPointsCurrent +=2;
        } else if (equipmentRow.get(a).name == "Lipids") {
          lPlayer.productivityPointsCurrent +=2;
        } else if (equipmentRow.get(a).name == "Cofee machine") {
          for (int b = 0; b < 5; b++) { 
            if (heroRow.get(b) != null) {
              heroRow.get(b).health++;
            }
          }
        }
      }
    }

    //decrease motivation
    for (int a = 0; a < 5; a++) {
      if (heroRow.get(a) != null) {
        if (heroRow.get(a).name != "JeffS") {
          heroRow.get(a).health--;
          if (heroRow.get(a).health <= 0) {
            deck.discardPile.add(board.topPlayer2.get(a));
            heroRow.set(a, null);
          }
        }
      }
    }
  }

  void edgeCases(Player lPlayer) {
    ArrayList<Card> heroRow = new ArrayList<Card>();
    ArrayList<Card> equipmentRow = new ArrayList<Card>();

    if (lPlayer == player) {
      heroRow = board.bottomPlayer1;
      equipmentRow = board.bottomPlayer2;
    } else if (lPlayer == foe) {
      heroRow = board.topPlayer2;
      equipmentRow = board.topPlayer1;
    }

    for (int a = 0; a < 5; a++) {
      if (heroRow.get(a) != null) {
        if (heroRow.get(a).name == "Josh") {
          heroRow.get(a).usedAbility = true;
        } else if (heroRow.get(a).name == "Stewart") {
          heroRow.get(a).productivity = 2;
          heroRow.get(a).usedAbility = true;
        } else if (heroRow.get(a).name == "JeffS") {
          println(lPlayer + "has Jeffs");
          if (game.jeffConference) {
            heroRow.get(a).health = 0;
            heroRow.get(a).productivity = 0;
            heroRow.get(a).strength = 0;
          }
        } else if (heroRow.get(a).name == "Ben") {
          heroRow.get(a).usedAbility = true;
        }
      }
    }
  }

  void playHero(Player lPlayer, int spaceIndex, int handIndex) {
    ArrayList<Card> heroRow = new ArrayList<Card>();

    int a = spaceIndex;
    int b = handIndex;

    if (lPlayer == player) {
      heroRow = board.bottomPlayer1;
    } else if (lPlayer == foe) {
      heroRow = board.topPlayer2;
    }

    heroRow.set(a, lPlayer.hand.get(b));

    if (heroRow.get(a).name == "Josh") {
      heroRow.get(a).usedAbility = true;
    } else if (heroRow.get(a).name == "Stewart") {
      heroRow.get(a).productivity = 2;
      heroRow.get(a).usedAbility = true;
    }


    lPlayer.hand.remove(b);

    for (int c = 0; c < 5; c++) {
      if (heroRow.get(c) != null) {
        if (heroRow.get(c).name == "Malaika") {
          heroRow.get(c).productivity = 1;
          heroRow.get(c).usedAbility = true;
          for (int d = 0; d < 5; d++) {
            if (d != c) {
              if (heroRow.get(d) != null) {
                heroRow.get(c).productivity = 6;
                break;
              }
            }
          }
        }
      }
    }
  }

  void purchaseEquipment(Player lPlayer, int spaceIndex, int handIndex) {
    ArrayList<Card> equipmentRow = new ArrayList<Card>();

    int a = spaceIndex;
    int b = handIndex;

    if (lPlayer == player) {
      equipmentRow = board.bottomPlayer2;
    } else if (lPlayer == foe) {
      equipmentRow = board.topPlayer1;
    }

    equipmentRow.set(a, board.equipmentSpaces.get(b));
    lPlayer.productivityPointsCurrent -= board.equipmentSpaces.get(b).requiredProductivity;

    board.equipmentSpaces.set(b, null);
    board.equipmentSpaces.set(b, deck.drawEquipmentCard());
  }

  void playAction( Player lPlayer, int handIndex) {
    ArrayList<Card> heroRow = new ArrayList<Card>();
    ArrayList<Card> equipmentRow = new ArrayList<Card>();

    ArrayList<Card> fHeroRow = new ArrayList<Card>();
    ArrayList<Card> fEquipmentRow = new ArrayList<Card>();

    Player flPlayer = null;

    int a = handIndex;

    if (lPlayer == player) {
      heroRow = board.bottomPlayer1;
      equipmentRow = board.bottomPlayer2;

      fHeroRow = board.topPlayer2;
      fEquipmentRow = board.topPlayer1;

      flPlayer = foe;
    } else if (lPlayer == foe) {
      heroRow = board.topPlayer2;
      equipmentRow = board.topPlayer1;

      fHeroRow = board.bottomPlayer1;
      fEquipmentRow = board.bottomPlayer2;

      flPlayer = player;
    }

    if (lPlayer.hand.get(a).name == "Tim's Run?") {
      int total = 0;
      for (int b = 0; b < 5; b++) {
        if (heroRow.get(b) != null) {
          heroRow.get(b).productivity -= 1;
          total++;
        }
      }
      lPlayer.productivityPointsCurrent += total;
      deck.discard(lPlayer.hand.get(a));
      lPlayer.hand.remove(lPlayer.hand.get(a));
    } else if (lPlayer.hand.get(a).name == "Spilled Chemicals") {
      boolean hasPPE = false;
      for (int b = 0; b < 5; b++) {
        if (fEquipmentRow.get(b) != null) {
          if (fEquipmentRow.get(b).name == "PPE") {
            hasPPE = true;
          }
        }
      }
      int numFoes = 0;
      for (int b = 0; b < 5; b++) {
        if (fEquipmentRow.get(b) != null) {
          numFoes++;
        }
      }
      if (numFoes > 0) {
        int rand = (int)random(5);
        boolean picking = true;
        while (picking) {
          if (fEquipmentRow.get(rand) != null) {
            picking = false;
          } else {
            rand = (int)random(5);
          }
        }
        if (hasPPE == false) {
          deck.discard(fEquipmentRow.get(rand));
          fEquipmentRow.set(rand, null);
        }
        deck.discard(lPlayer.hand.get(a));
        lPlayer.hand.remove(lPlayer.hand.get(a));
      } else {
        game.changeCurrentText("No valid equipment");
      }
    } else if (lPlayer.hand.get(a).name == "Time For Class") {
      for (int b = 0; b < 5; b++) {
        if (fHeroRow.get(b) != null) {
          fHeroRow.get(b).health = 1;
        }
      }
      deck.discard(lPlayer.hand.get(a));
      lPlayer.hand.remove(lPlayer.hand.get(a));
    } else if (lPlayer.hand.get(a).name == "Free Food!!!!") {
      for (int b = 0; b < 5; b++) {
        if (heroRow.get(b) != null) {
          heroRow.get(b).productivity++;
        }
      }
      deck.discard(lPlayer.hand.get(a));
      lPlayer.hand.remove(lPlayer.hand.get(a));
    } else if (lPlayer.hand.get(a).name == "Awful Student") {
      int numFoes = 0;
      for (int b = 0; b < 5; b++) {
        if (fHeroRow.get(b) != null) {
          numFoes++;
        }
      }
      if (numFoes > 0) {
        int rand = (int)random(5);
        boolean picking = true;
        while (picking) {
          if (fHeroRow.get(rand) != null) {
            picking = false;
          } else {
            rand = (int)random(5);
          }
        }
        deck.discard(fHeroRow.get(rand));
        fHeroRow.set(rand, null);
        deck.discard(lPlayer.hand.get(a));
        lPlayer.hand.remove(lPlayer.hand.get(a));
      } else {
        game.changeCurrentText("No valid choice");
      }
    } else if (lPlayer.hand.get(a).name == "Is it over yet?") {
      int numChoices = 0;
      for (int b = 0; b < 5; b++) {
        if (heroRow.get(b) != null) {
          numChoices++;
        }
      }
      if (numChoices > 0) {
        int rand = (int)random(5);
        boolean picking = true;
        while (picking) {
          if (heroRow.get(rand) != null) {
            picking = false;
          } else {
            rand = (int)random(5);
          }
        }
        if (heroRow.get(rand).name != "Karl") {
          lPlayer.productivityPointsCurrent += heroRow.get(rand).productivity;
        } else {
          lPlayer.productivityPointsCurrent += heroRow.get(rand).productivity * 2;
        }
        deck.discard(lPlayer.hand.get(a));
        lPlayer.hand.remove(lPlayer.hand.get(a));
      } else {
        game.changeCurrentText("No valid choice");
      }
    } else if (lPlayer.hand.get(a).name == "How late you stayin'?") {
      int numFoes = 0;
      for (int b = 0; b < 5; b++) {
        if (fHeroRow.get(b) != null) {
          numFoes++;
        }
      }
      if (numFoes > 0) {
        int rand = (int)random(5);
        boolean picking = true;
        while (picking) {
          if (fHeroRow.get(rand) != null) {
            picking = false;
          } else {
            rand = (int)random(5);
          }
        }
        fHeroRow.get(rand).health -= 2;
        if (fHeroRow.get(rand).health < 0) {
          deck.discard(fHeroRow.get(rand));
          fHeroRow.set(rand, null);
        }

        deck.discard(lPlayer.hand.get(a));
        lPlayer.hand.remove(lPlayer.hand.get(a));
      } else {
        game.changeCurrentText("No valid choice");
      }
    } else if (lPlayer.hand.get(a).name == "Spin the wheel!") {
      for (int b = 0; b < 5; b++) {
        if (fHeroRow.get(b) != null) {
          if (fHeroRow.get(b).name == "Frank") {
            deck.discard(fHeroRow.get(b));
            fHeroRow.set(b, null);
          }
        }

        if (heroRow.get(b) != null) {
          if (heroRow.get(b).name ==" Frank") {
            deck.discard(heroRow.get(b));
            heroRow.set(b, null);
          }
        }
      }

      for (int b = 0; b < 5; b++) {
        if (heroRow.get(b) != null) {
          heroRow.get(b).productivity++;
        }
      }

      deck.discard(lPlayer.hand.get(a));
      lPlayer.hand.remove(lPlayer.hand.get(a));
    } else if (lPlayer.hand.get(a).name == "Dishwasher") {
      boolean foundEmma = false;
      int numHero = 0;
      for (int b = 0; b < 5; b++) {
        if (heroRow.get(b) != null) {
          numHero++;
          if (heroRow.get(b).name == "Emma") {
            heroRow.get(b).productivity += 2;
            foundEmma = true;
            deck.discard(lPlayer.hand.get(a));
            lPlayer.hand.remove(lPlayer.hand.get(a));
          }
        }
      }
      if (numHero > 0) {
        if (foundEmma == false) {
          boolean foundChoice = false;
          int rand = (int)random(5);
          while (foundChoice == false) {
            if (heroRow.get(rand) != null) {
              foundChoice = true;
            } else {
              rand = (int)random(5);
            }
          }
          heroRow.get(rand).productivity++;
          deck.discard(lPlayer.hand.get(a));
          lPlayer.hand.remove(lPlayer.hand.get(a));
        }
      } else {
        game.changeCurrentText("No valid choice");
      }
    } else if (lPlayer.hand.get(a).name == "Meme-full Presentation") {
      int numHeroes = 0;
      for (int b = 0; b < 5; b++) {
        if (heroRow.get(b) != null) {
          numHeroes++;
        }
      }
      if (numHeroes > 0) {
        for (int b = 0; b < 5; b++) {
          if (heroRow.get(b) != null) {
            heroRow.get(b).health += 2;
          }
        }
        deck.discard(lPlayer.hand.get(a));
        lPlayer.hand.remove(lPlayer.hand.get(a));
      } else {
        game.changeCurrentText("No valid choice");
      }
    } else if (lPlayer.hand.get(a).name == "It's my jam!") {
      int numHeroes = 0;
      for (int b = 0; b < 5; b++) {
        if (heroRow.get(b) != null) {
          numHeroes++;
        }
      }
      if (numHeroes > 0) {
        for (int b = 0; b < 5; b++) {
          if (heroRow.get(b) != null) {
            heroRow.get(b).productivity++;

            if (heroRow.get(b).name == "Emma") {
              heroRow.get(b).productivity++;
            } else if (heroRow.get(b).name == "Chelsey") {
              heroRow.get(b).productivity++;
            }
          }
        }
        deck.discard(lPlayer.hand.get(a));
        lPlayer.hand.remove(lPlayer.hand.get(a));
      } else {
        game.changeCurrentText("No valid choice");
      }
    } else if (lPlayer.hand.get(a).name == "I forgot to save!") {
      boolean hasBook = false;
      for (int b = 0; b < 5; b++) {
        if (fEquipmentRow.get(b) != null) {
          if (fEquipmentRow.get(b).name == "Lab Notebook") {
            hasBook = true;
          }
        }
      }
      if (hasBook == false) {
        flPlayer.productivityPointsCurrent -= 5;
        if (flPlayer.productivityPointsCurrent < 0 ) {
          flPlayer.productivityPointsCurrent = 0;
        }
        deck.discard(lPlayer.hand.get(a));
        lPlayer.hand.remove(lPlayer.hand.get(a));
      }
    } else if (lPlayer.hand.get(a).name == "Nature Paper") {
      lPlayer.productivityPointsCurrent += 4;
      deck.discard(lPlayer.hand.get(a));
      lPlayer.hand.remove(lPlayer.hand.get(a));
    }
  }


  void activateAbility(Player lPlayer, int spaceIndex) {

    ArrayList<Card> heroRow = new ArrayList<Card>();
    ArrayList<Card> equipmentRow = new ArrayList<Card>();

    ArrayList<Card> fHeroRow = new ArrayList<Card>();
    ArrayList<Card> fEquipmentRow = new ArrayList<Card>();


    int a = spaceIndex;

    if (lPlayer == player) {
      heroRow = board.bottomPlayer1;
      equipmentRow = board.bottomPlayer2;

      fHeroRow = board.topPlayer2;
      fEquipmentRow = board.topPlayer1;
    } else if (lPlayer == foe) {
      heroRow = board.topPlayer2;
      equipmentRow = board.topPlayer1;

      fHeroRow = board.bottomPlayer1;
      fEquipmentRow = board.bottomPlayer2;
    }


    if (heroRow.get(a).name == "Christian") {
      drawCard(lPlayer);
      heroRow.get(a).usedAbility = true;
    } else if (heroRow.get(a).name == "Karl") {
      int numEquipmentSpaces = 0;
      for (int b = 0; b < 5; b++) {
        if (equipmentRow.get(b) == null) {
          numEquipmentSpaces++;
        }
      }
      if (numEquipmentSpaces > 0 ) {
        int ranEquipmentSpace = (int)random(5);
        while (equipmentRow.get(ranEquipmentSpace) != null) {
          ranEquipmentSpace = (int)random(5);
        }
        for (int b = 0; b< deck.discardPile.size(); b++) {
          if (deck.discardPile.get(b).name == "MS") {
            equipmentRow.set(ranEquipmentSpace, deck.discardPile.get(b));
            deck.discardPile.remove(b);
            changeCurrentText("Fixing MS");
            heroRow.get(a).usedAbility = true;
            break;
          } else if (deck.discardPile.get(b).name == "LCMS") {
            equipmentRow.set(ranEquipmentSpace, deck.discardPile.get(b));
            deck.discardPile.remove(b);
            changeCurrentText("Fixing LCMS");
            heroRow.get(a).usedAbility = true;
            break;
          } else {
            game.changeCurrentText("Nothing in the discard pile.");
            heroRow.get(a).usedAbility = true;
          }
        }
      } else {
        game.changeCurrentText("Not enough equipment space.");
        heroRow.get(a).usedAbility = true;
      }
    } else if (heroRow.get(a).name == "JeffS") {
      game.jeffConference = true; 
      jeffPlayer = lPlayer;
      heroRow.get(a).nickname = "Is Jeff around?"; 
      heroRow.get(a).productivity = 0; 
      heroRow.get(a).strength = 0; 
      heroRow.get(a).health = 0; 
      heroRow.get(a).usedAbility = true;
    } else if (heroRow.get(a).name == "Sam") {
      int ran = (int)(random(5)+1); 
      lPlayer.productivityPointsCurrent += ran; 
      game.changeCurrentText(" Gained " + ran + " point(s)!");
      heroRow.get(a).usedAbility = true;
    } else if (heroRow.get(a).name == "Frank") {
      for (int b = 0; b < 5; b++) {
        if (b != a) {
          if (heroRow.get(b) != null) {
            heroRow.get(b).productivity++; 
            heroRow.get(a).usedAbility = true;
          }
        }
      }
    } else if (heroRow.get(a).name == "JeffM") {
      int numFoes = 0; 
      for (int b = 0; b < 5; b++) {
        if (fHeroRow.get(b) != null) {
          numFoes++;
        }
      }
      if (numFoes > 0) {
        boolean pickedTarget = false; 
        int rand = 0; 
        while (pickedTarget == false) {
          rand = (int)random(5); 
          if (fHeroRow.get(rand) != null) {
            pickedTarget = true;
          }
        }
        fHeroRow.get(rand).productivity = 0; 
        heroRow.get(a).productivity = 0;
      } else {
        game.changeCurrentText("No valid targets");
      }

      heroRow.get(a).usedAbility = true;
    } else if (heroRow.get(a).name == "Emma") {
      for (int b = 0; b < 5; b++) {
        if (heroRow.get(b) != null) {
          if ( b != a) {
            heroRow.get(b).health++; 
            heroRow.get(a).usedAbility = true;
          }
        }
      }
    } else if (heroRow.get(a).name == "John") {
      lPlayer.productivityPointsCurrent += 3;
      heroRow.get(a).usedAbility = true;
    } else if (heroRow.get(a).name == "Chelsey") {
      int numHeroes = 0; 
      for (int b = 0; b < 5; b++) {
        if (heroRow.get(b) != null) {
          numHeroes++;
        }
      }
      if (numHeroes > 0) {
        boolean pickedTarget = false; 
        int rand = 0; 
        while (pickedTarget == false) {
          rand = (int)random(5); 
          if (heroRow.get(rand) != null) {
            pickedTarget = true;
          }
        }
        heroRow.get(rand).health = 5;
      } else {
        game.changeCurrentText("No valid targets");
      }

      heroRow.get(a).usedAbility = true;
    } else if (heroRow.get(a).name == "Wondu") {
      heroRow.get(a).productivity++;
      heroRow.get(a).health--;
      heroRow.get(a).usedAbility = true;
    }
  }

  int getStrength(Player lPlayer) {
    ArrayList<Card> heroRow = new ArrayList<Card>();

    int totalStrength =  0;

    if (lPlayer == player) {
      heroRow = board.bottomPlayer1;
    } else if (lPlayer == foe) {
      heroRow = board.topPlayer2;
    }

    for (int c = 0; c < 5; c++) {
      if (heroRow.get(c) != null) {
        totalStrength += heroRow.get(c).strength;
      }
    }

    return totalStrength;
  }

  void cpuTurn() {
    //reset abilities
    resetAbilities(foe);

    //edge cases
    edgeCases(foe);

    changeCurrentText("Foe turn");
    //draw card
    drawCard(foe);



    //gettting hand info
    int numHeroes = 0;
    int numActions = 0;
    int numHeroSpaces = 0;
    int numEquipmentSpaces = 0;

    for (int a = 0; a < foe.hand.size(); a++) { 
      if (foe.hand.get(a).type == "CardHero") {
        numHeroes++;
      } else if (foe.hand.get(a).type == "CardAction") {
        numActions++;
      } else {
      }
    }

    for (int a = 0; a < 5; a++) {
      if (board.topPlayer1.get(a) == null) {
        numEquipmentSpaces++;
      }
      if (board.topPlayer2.get(a) == null) {
        numHeroSpaces++;
      }
    }

    if ((numHeroes > 0) && (numHeroSpaces > 0)) {
      int ranHero = (int)random(foe.hand.size());
      while (foe.hand.get(ranHero).type == "CardAction") {
        ranHero = (int)random(foe.hand.size());
      }

      int ranSpace = (int)random(5);
      while (board.topPlayer2.get(ranSpace) != null) {
        ranSpace = (int)random(5);
      }
      changeCurrentText("Recruited " + foe.hand.get(ranHero).name);
      playHero(foe, ranSpace, ranHero);
    }

    //activate action
    if (numActions > 0) {
      int ranAction = (int)random(foe.hand.size());
      while (foe.hand.get(ranAction).type == "CardHero") {
        ranAction = (int)random(foe.hand.size());
      }
      changeCurrentText("Played " + foe.hand.get(ranAction).name);
      playAction(foe, ranAction);
    }


    //purchase equipment
    if (numEquipmentSpaces > 0) {
      int ranEquipment = (int)random(3);

      int ranSpace = (int)random(5);
      while (board.topPlayer1.get(ranSpace) != null) {
        ranSpace = (int)random(5);
      }


      if (foe.productivityPointsCurrent >= board.equipmentSpaces.get(ranEquipment).requiredProductivity) {
        int totalStrength = getStrength(foe);
        if (totalStrength > board.equipmentSpaces.get(ranEquipment).requiredStrength) {
          changeCurrentText("Purchased " + board.equipmentSpaces.get(ranEquipment).name);
          purchaseEquipment(foe, ranSpace, ranEquipment);
        }
      }
    }

    //activate abilities
    for (int a = 0; a < 5; a++) {
      if (board.topPlayer2.get(a) != null) {
        if (board.topPlayer2.get(a).usedAbility == false) {
          changeCurrentText("Activated " + board.topPlayer2.get(a).name + "'s ability");
          activateAbility(foe, a);
        }
      }
    }

    //buy points
    if (foe.productivityPointsCurrent > 10) {
      changeCurrentText("Bought an accomplishment point");
      accomplish(foe);
    }

    //end turn
    endTurnMaintenance(foe);

    changeCurrentText("Your turn");
    /////////////////////////////////////pre player turn
    //change turn to player
    if (deck.drawPile.size() > 0) {
      waitingDraw = true;
    }

    //reset abilitties
    resetAbilities(player);

    //edge cases
    edgeCases(player);
  }


  void accomplish(Player player) {
    if (player.productivityPointsCurrent >= 10 ) {
      player.productivityPointsCurrent -=10;
      player.accomplishmentPoints++;
    } else {
      changeCurrentText("Not enough accomplishment points");
    }
  }
}
