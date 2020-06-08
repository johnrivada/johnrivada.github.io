import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class The_Lab extends PApplet {

GameState game;

Player player;
Player foe;

Board board;

Deck deck;

Card nullCard;
CardEquipment nullEquipment;
Card highlightedCard;

Descriptions descriptions;

public void setup() {
  
  background(255);
  setupGame();
  newGame();
}

public void draw() {
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



public void setupGame() {
  nullCard = new Card("null");
  nullEquipment = new CardEquipment("Empty", 999);
  descriptions = new Descriptions();
}

public void newGame() {
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


public void mouseClicked() {
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

public boolean mouseOver(int x, int y, int wid, int len) {
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


public void keyPressed() {
  if (key == 'a') {
  } else if (keyCode == UP) {
  } else if (keyCode == DOWN) {
  } else if (keyCode == ENTER) {
  }
}

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

  public void draw() {
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
class Card {
  String type = "Card";
  
  boolean clicked = false;
  boolean clickedAbility = false;
  boolean usedAbility = false;
  boolean clickedAction = false;

  int clickedX = 0;
  int clickedY = 0;

  int cardLength = 50;
  int cardWidth = 50;

  String name = "";
  String nickname = "";

  int productivity = 0;
  String  abilityName = "ability";

  String description;

  int strength = 0;
  int health = 0;

  PImage img;

  Card() {
  }

  Card(String n) {
    name = n;
  }

  public void highlighted() {
  }

  public void selected() {
    fill(255);
    rect(clickedX, clickedY, 100, 20);
    fill(0);
    textAlign(CENTER);
    text("Play", clickedX+50, clickedY+15);
    textAlign(LEFT);
  }

  public void selectedAbility() {
    fill(255);
    rect(clickedX, clickedY, 100, 20);
    fill(0);
    textAlign(CENTER);
    text(abilityName, clickedX+50, clickedY+15);
    textAlign(LEFT);
  }

  public void selectedAction() {
    fill(255);
    rect(clickedX, clickedY, 100, 20);
    fill(0);
    textAlign(CENTER);
    text("Activate", clickedX+50, clickedY+15);
    textAlign(LEFT);
  }

  public void clicked() {
    clicked = true;
    clickedX = mouseX;
    clickedY = mouseY;
  }

  public void clickedAbility() {
    clickedAbility = true;
    clickedX = mouseX;
    clickedY = mouseY;
  }

  public void clickedAction() {
    clickedAction = true;
    clickedX = mouseX;
    clickedY = mouseY;
  }

  public void unclicked() {
    clicked = false;
    clickedAbility = false;
    clickedAction= false;
    clickedX = -1;
    clickedY = -1;
  }

  public void displayImage(int x, int y, int w, int l) {
    if (img != null) {
      image(img, x+1, y+1, w-1, l-1);
    }
  }
}
class CardAction extends Card {


  CardAction(String n) {
    name = n;
    type = "CardAction";
  }

  public void highlighted() {

    //rect(690, 290, 300, 420);
    textSize(30);
    textAlign(CENTER, CENTER);
    fill(0);
    text(name, 840, 310);
    textSize(11);
    rect(765, 350, 150, 150);
    displayImage(765, 350, 150, 150);
    textAlign(LEFT, BASELINE);
    textSize(17);
    if (description != null) {
      text(description, 700, 510, 280, 110);
    }
    textSize(11);
  }
}

class CardEquipment extends Card {
  int requiredProductivity = 0;
  int requiredStrength = 0;
  String description;

  CardEquipment(String n, int r) {
    super(n);
    requiredProductivity = r;
    type = "CardEquipment";
  }


  public void highlighted() {

    textSize(30);
    textAlign(CENTER, CENTER);
    fill(0);
    text(name, 840, 310);
    textSize(11);
    rect(765, 350, 150, 150);
    displayImage(765, 350, 150, 150);
    text("Required Productivity: " + requiredProductivity, 840, 510);
    textAlign(LEFT, BASELINE);
    textSize(17);
    if (description != null) {
      text(description, 700, 525, 280, 110);
    }
    textSize(11);
  }
}
class CardHero extends Card {

  String affiliation = "";



  boolean abilityClicked = false;


  CardHero(String n, String nn, String a, int ip, int is, int ih) {
    super(n);
    nickname = nn;
    affiliation = a;
    productivity = ip;
    strength = is;
    health = ih;
    type = "CardHero";
  }

  public void highlighted() {
    textSize(30);
    textAlign(CENTER, CENTER);
    fill(0);
    text(nickname, 840, 310);
    textSize(11);
    text(name, 840, 340);
    rect(765, 350, 150, 150);
    displayImage(765, 350, 150, 150);

    text(affiliation + " Group", 840, 510);
    text("Productivity: " + productivity, 840, 525);
    text("Strength: " + strength, 840, 540);
    text("Motivation: " + health, 840, 555);
    textAlign(LEFT, BASELINE);
    textSize(17);
    if (description != null) {
      text(description, 700, 580, 280, 110);
    }
    textSize(11);
  }

  public void clicked() {
    abilityClicked = true;

    clicked = true;
    clickedX = mouseX;
    clickedY = mouseY;
  }
}
class Deck {
  ArrayList<Card> drawList;
  ArrayList<Card> drawPile;
  ArrayList<Card> discardPile;

  ArrayList<CardEquipment> equipmentList;
  ArrayList<CardEquipment> equipmentPile;

  Deck() {
    drawList = new ArrayList<Card>();

    drawList.add(new CardHero("Christian", "C Rose", "Smith", 1, 3, (int)random(5)+2));
    drawList.add(new CardHero("Emma", "Ooma", "Smith", 3, 2, (int)random(5)+2));
    drawList.add(new CardHero("Frank", "Franklin", "Smith", 2, 1, (int)random(5)+2));
    drawList.add(new CardHero("Ben", "B Jammin", "Manthorpe", 2, 2, 5));
    drawList.add(new CardHero("Chelsey", "#DriveForFive", "Manthorpe", 2, 2, (int)random(5)+2));
    drawList.add(new CardHero("John", "J Pex", "Manthorpe", 2, 1, (int)random(5)+2));
    drawList.add(new CardHero("Josh", "J Rock", "Smith", 3, 2, (int)random(5)+2));
    drawList.add(new CardHero("Malaika", "M/Z Mine", "Smith", 1, 1, (int)random(5)+2));
    drawList.add(new CardHero("Wondu", "Wondu", "Smith", 2, 2, (int)random(5)+2));
    drawList.add(new CardHero("JeffS", "Jefe", "Smith", 2, 3, (int)random(5)+2));
    drawList.add(new CardHero("JeffM", "Boom Boom", "Manthorpe", 1, 3, (int)random(5)+2));
    drawList.add(new CardHero("Karl", "KarlVWasslen", "Smith", 1, 3, (int)random(5)+2));
    drawList.add(new CardHero("Stewart", "Stew", "Smith", 2, 2, (int)random(5)+2));
    drawList.add(new CardHero("Sam", "SMA", "Manthorpe", 2, 3, (int)random(5)+2));
    drawList.add(new CardAction("Tim's Run?"));
    drawList.add(new CardAction("Spilled Chemicals"));
    drawList.add(new CardAction("Time For Class"));
    drawList.add(new CardAction("Free Food!!!!"));
    drawList.add(new CardAction("Awful Student"));
    drawList.add(new CardAction("Is it over yet?"));
    drawList.add(new CardAction("How late you stayin'?"));
    drawList.add(new CardAction("Spin the wheel!"));
    drawList.add(new CardAction("Dishwasher"));
    drawList.add(new CardAction("Meme-full Presentation"));
    drawList.add(new CardAction("It's my jam!"));
    drawList.add(new CardAction("I forgot to save!"));
    drawList.add(new CardAction("Nature Paper"));

    drawList.get(0).img = loadImage("photos/christian.jpg");
    drawList.get(1).img =loadImage("photos/emma.jpg");
    drawList.get(2).img =loadImage("photos/frank.jpg");
    drawList.get(3).img =loadImage("photos/ben.jpg");
    drawList.get(4).img =loadImage("photos/chelsey.jpg");
    drawList.get(5).img =loadImage("photos/john.jpg");
    drawList.get(6).img =loadImage("photos/josh.jpg");
    drawList.get(7).img =loadImage("photos/malaika.jpg");
    drawList.get(8).img =loadImage("photos/wondu.jpg");
    drawList.get(9).img =loadImage("photos/jeffs.jpg");
    drawList.get(10).img =loadImage("photos/jeffm.jpg");
    drawList.get(11).img =loadImage("photos/karl.jpg");
    drawList.get(12).img =loadImage("photos/stewart.jpg");
    drawList.get(13).img =loadImage("photos/sam.jpg");
    
    drawList.get(14).img =loadImage("photos/tims.jpg");
    drawList.get(15).img =loadImage("photos/spill.jpg");
    drawList.get(16).img =loadImage("photos/class.jpg");
    drawList.get(17).img =loadImage("photos/food.jpg");
    drawList.get(18).img =loadImage("photos/student.jpg");
    drawList.get(19).img =loadImage("photos/4908.jpg"); 
    drawList.get(20).img =loadImage("photos/dewar.jpg");
    drawList.get(21).img =loadImage("photos/wheel.jpg");
    drawList.get(22).img =loadImage("photos/dishwasher.jpg");
    drawList.get(23).img =loadImage("photos/meme.jpg"); //music
    drawList.get(24).img =loadImage("photos/music.jpg");
    drawList.get(25).img =loadImage("photos/save.jpg");
    drawList.get(26).img =loadImage("photos/paper.jpg");

    drawPile = new ArrayList<Card>();
    discardPile = new ArrayList<Card>();
    for (int a = 0; a < drawList.size(); a++) {
      drawPile.add(drawList.get(a));
    }


    equipmentPile = new ArrayList<CardEquipment>();
    equipmentList = new ArrayList<CardEquipment>();

    equipmentList.add(new CardEquipment("MS", 6));
    equipmentList.add(new CardEquipment("NMR", 5));
    equipmentList.add(new CardEquipment("PPE", 1));
    equipmentList.add(new CardEquipment("Lab Notebook", 1));
    equipmentList.add(new CardEquipment("Radio", 2));
    equipmentList.add(new CardEquipment("Coffee Machine", 1));
    equipmentList.add(new CardEquipment("LCMS", 2));
    equipmentList.add(new CardEquipment("Bubbler", 3));
    equipmentList.add(new CardEquipment("DZM", 4));
    equipmentList.add(new CardEquipment("Lipids", 2));

    
    equipmentList.get(0).img = loadImage("photos/ms.jpg");
    equipmentList.get(1).img = loadImage("photos/nmr.jpg");
    equipmentList.get(2).img = loadImage("photos/ppe.jpg");
    equipmentList.get(3).img = loadImage("photos/book.jpg");
    equipmentList.get(4).img = loadImage("photos/radio.jpg");
    equipmentList.get(5).img = loadImage("photos/coffee.jpg");
    equipmentList.get(6).img = loadImage("photos/lcms.jpg");
    equipmentList.get(7).img = loadImage("photos/bubbler.jpg");
    equipmentList.get(8).img = loadImage("photos/dzm.jpg");
    equipmentList.get(9).img = loadImage("photos/lipid.jpg");
    
    for (int a = 0; a < equipmentList.size(); a++) {
      equipmentPile.add(equipmentList.get(a));
    }

    equipmentList.get(0).requiredStrength = 6;
    equipmentList.get(1).requiredStrength = 6;
    equipmentList.get(6).requiredStrength = 5;
    equipmentList.get(7).requiredStrength = 3;
  }

  public Card drawCard() {
    Card drawnCard = drawPile.get((int)random(drawPile.size()));
    drawPile.remove(drawnCard);
    return drawnCard;
  }

  public Card drawCard(int a) {
    Card drawnCard = drawPile.get(a);
    drawPile.remove(drawnCard);

    return drawnCard;
  }

  public CardEquipment drawEquipmentCard() {
    if (equipmentPile.size() > 0) {
      CardEquipment drawnCard = equipmentPile.get((int)random(equipmentPile.size()));
      equipmentPile.remove(drawnCard);
      return drawnCard;
    } else { 
      return nullEquipment;
    }
  }


  public void discard(Card card) {
    discardPile.add(card);
  }
}
class Descriptions {
  ArrayList<String> equipment = new ArrayList<String>();
  ArrayList<String> abilityNames = new ArrayList<String>();
  ArrayList<String> abilities = new ArrayList<String>();
  ArrayList<String> actions = new ArrayList<String>();

  Descriptions() {
    equipment.add("Requires 6 Strength to purchase. If Karl or Josh or Christian is in your lab, you gain +3 productivity points each turn.");
    equipment.add("Requires 6 Strength to purchase. If John or Chelsey or Sam is in your lab, you gain +3 productivity points each turn.");
    equipment.add("Your lab becomes immune the 'Chemical Spills' Card.");
    equipment.add("Your lab becomes immune to the 'I forgot to save!' Card.");
    equipment.add("+1 productivity per turn.");
    equipment.add("+1 motivation to each group member per turn.");
    equipment.add("Requires 5 Strength to purchase. If Frank or Emma or Stewart is in your lab, you gain +3 productivity points each turn.");
    equipment.add("Requires 3 Strength to purchase. If Ben or Wondu or Malaika is in your lab, you gain +3 productivity points each turn.");
    equipment.add("+2 productivity per turn.");
    equipment.add("+2 productivity per turn.");

    abilities.add("Socialite: Activate to draw an extra card.");
    abilities.add("Motivator: All other members get +1 motivation.");
    abilities.add("Skor Bars: All other members in your lab get +1 productivity.");
    abilities.add("Motivated: Ben's starting motivation is always 5.");
    abilities.add("Ellie: Chelse brings Ellie to school. Set a random member's motivation to 5.");
    abilities.add("We Need To Go Deeper: Make a card game based off the members of your lab. +3 productivity points.");
    abilities.add("Python Scripts: Josh is able to automate scripts. If Josh gets discarded, instantly gain +4 productivity points");
    abilities.add("Undergrad: If Malaika is the only member in your lab, her productivity becomes 1. Otherwise it becomes 6.");
    abilities.add("MCAT: +1 productivity but also -1 motivation");
    abilities.add("At A Conference: JS leaves for a conference, turning all this stats to 0. When he comes back you instantly gain 10 productivity points.");
    abilities.add("Windbaggery: JM chooses an opposing lab member at random. Both of their productivities become 0.");
    abilities.add("CMSC: If the LCMS or MS are in the discard pile, you can activate this card to place one in your equipment row (will prioritize the MS).");
    abilities.add("Offsite: Events at CU don't affect Stewart. His productivity at the end of each turn is reset to its default value.");
    abilities.add("Get Sh*t Done: Activate to randomly gain 1-5 productivity points.");

    abilityNames.add("Socialite");
    abilityNames.add("Motivator:");
    abilityNames.add("Skor");
    abilityNames.add("Motivated");
    abilityNames.add("Ellie");
    abilityNames.add("Go Deeper");
    abilityNames.add("Python Scripts");
    abilityNames.add("Undergrad");
    abilityNames.add("MCAT");
    abilityNames.add("Conference");
    abilityNames.add("Windbaggery");
    abilityNames.add("CMSC");
    abilityNames.add("HC");
    abilityNames.add("Get Sh*t Done");

    abilities.add("+1 productivity points per group member. Each group member loses 1 productivity.");
    abilities.add("A random opposing group member spilled chemicals everywhere. Discard a random opposing equipment.");
    abilities.add("All opposing students get their motivation set to 1.");
    abilities.add("Each group member gain +1 productivity.");
    abilities.add("Your first 4908 student is horrible. Discard a random opposing group member.");
    abilities.add("Your 4908 defence lasted 2.5 hours. Gain productivity equal to a random group member but they lose 1 motivation. Effects are doubled if its Karl.");
    abilities.add("Choose an opposing group member to stay and watch the dewars. They lose 2 motivation.");
    abilities.add("You spin the wheel and had to sing. Discard Frank, all group members gain +1 productivity.");
    abilities.add("If Emma is a group member, she gains +2 productivity. Otherwise a random member gets +1 productivity.");
    abilities.add("Your presentation was full of memes. Every group member gets +2 motivation.");
    abilities.add("Country music starts blaring through the lab. Chelsey & Emma get +2 productivity, everyone else gets +1 productivity.");
    abilities.add("You forgot to save your weekend long run. Opposing lab loses 5 productivity points.");
    abilities.add("Gain +4 productivity points.");
    
    
  }

  public void init() {
    deck.equipmentList.get(0).description = equipment.get(0);
    deck.equipmentList.get(1).description = equipment.get(1);
    deck.equipmentList.get(2).description = equipment.get(2);
    deck.equipmentList.get(3).description = equipment.get(3);
    deck.equipmentList.get(4).description = equipment.get(4);
    deck.equipmentList.get(5).description = equipment.get(5);
    deck.equipmentList.get(6).description = equipment.get(6);
    deck.equipmentList.get(7).description = equipment.get(7);
    deck.equipmentList.get(8).description = equipment.get(8);
    deck.equipmentList.get(9).description = equipment.get(9);

    for (int a = 0; a < 14; a++) {
      deck.drawList.get(a).description = abilities.get(a);
      deck.drawList.get(a).abilityName = abilityNames.get(a);
    }

    for (int a = 14; a < deck.drawList.size(); a++) {
      deck.drawList.get(a).description = abilities.get(a);
    }
    
 
  }
}
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

  public void draw() {
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

  public void changeCurrentText(String str) {
    if (str != textNotif.get(textNotif.size()-1)) {
      textNotif.add(str);
      if (textNotif.size() > 9) {
        textNotif.remove(0);
      }
    }
  }


  public void resetAbilities(Player lPlayer) {
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

  public void drawCard(Player lPlayer) {
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


  public void endTurnMaintenance(Player lPlayer) {
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

  public void edgeCases(Player lPlayer) {
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

  public void playHero(Player lPlayer, int spaceIndex, int handIndex) {
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

  public void purchaseEquipment(Player lPlayer, int spaceIndex, int handIndex) {
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

  public void playAction( Player lPlayer, int handIndex) {
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


  public void activateAbility(Player lPlayer, int spaceIndex) {

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

  public int getStrength(Player lPlayer) {
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

  public void cpuTurn() {
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


  public void accomplish(Player player) {
    if (player.productivityPointsCurrent >= 10 ) {
      player.productivityPointsCurrent -=10;
      player.accomplishmentPoints++;
    } else {
      changeCurrentText("Not enough accomplishment points");
    }
  }
}

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

  public void draw() {
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

  public void drawCard() {
    hand.add(deck.drawCard());
  }

  public void drawHand() {
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

  public void drawSelected() {
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

  public void checkClicks() {
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
  public void settings() {  size(1000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "The_Lab" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
