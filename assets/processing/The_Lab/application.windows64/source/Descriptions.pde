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

  void init() {
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
