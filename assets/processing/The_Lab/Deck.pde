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

  Card drawCard() {
    Card drawnCard = drawPile.get((int)random(drawPile.size()));
    drawPile.remove(drawnCard);
    return drawnCard;
  }

  Card drawCard(int a) {
    Card drawnCard = drawPile.get(a);
    drawPile.remove(drawnCard);

    return drawnCard;
  }

  CardEquipment drawEquipmentCard() {
    if (equipmentPile.size() > 0) {
      CardEquipment drawnCard = equipmentPile.get((int)random(equipmentPile.size()));
      equipmentPile.remove(drawnCard);
      return drawnCard;
    } else { 
      return nullEquipment;
    }
  }


  void discard(Card card) {
    discardPile.add(card);
  }
}
