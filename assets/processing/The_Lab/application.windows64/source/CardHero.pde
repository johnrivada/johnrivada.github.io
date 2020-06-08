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

  void highlighted() {
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

  void clicked() {
    abilityClicked = true;

    clicked = true;
    clickedX = mouseX;
    clickedY = mouseY;
  }
}
