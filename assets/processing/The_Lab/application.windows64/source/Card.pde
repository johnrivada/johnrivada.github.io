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

  void highlighted() {
  }

  void selected() {
    fill(255);
    rect(clickedX, clickedY, 100, 20);
    fill(0);
    textAlign(CENTER);
    text("Play", clickedX+50, clickedY+15);
    textAlign(LEFT);
  }

  void selectedAbility() {
    fill(255);
    rect(clickedX, clickedY, 100, 20);
    fill(0);
    textAlign(CENTER);
    text(abilityName, clickedX+50, clickedY+15);
    textAlign(LEFT);
  }

  void selectedAction() {
    fill(255);
    rect(clickedX, clickedY, 100, 20);
    fill(0);
    textAlign(CENTER);
    text("Activate", clickedX+50, clickedY+15);
    textAlign(LEFT);
  }

  void clicked() {
    clicked = true;
    clickedX = mouseX;
    clickedY = mouseY;
  }

  void clickedAbility() {
    clickedAbility = true;
    clickedX = mouseX;
    clickedY = mouseY;
  }

  void clickedAction() {
    clickedAction = true;
    clickedX = mouseX;
    clickedY = mouseY;
  }

  void unclicked() {
    clicked = false;
    clickedAbility = false;
    clickedAction= false;
    clickedX = -1;
    clickedY = -1;
  }

  void displayImage(int x, int y, int w, int l) {
    if (img != null) {
      image(img, x+1, y+1, w-1, l-1);
    }
  }
}
