class CardEquipment extends Card {
  int requiredProductivity = 0;
  int requiredStrength = 0;
  String description;

  CardEquipment(String n, int r) {
    super(n);
    requiredProductivity = r;
    type = "CardEquipment";
  }


  void highlighted() {

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
