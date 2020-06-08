class CardAction extends Card {


  CardAction(String n) {
    name = n;
    type = "CardAction";
  }

  void highlighted() {

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
