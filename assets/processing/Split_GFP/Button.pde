class Button {
  int index = -1;
  int x = -1;
  int y = -1;
  int bHeight = 50;
  int bWidth = 250;
  color buttonFill;
  color hoverFill;
  boolean hover = false;
  boolean isClicked = false;
  String buttonText = "Give fragment 1 to";

  Button(int ii, int ix, int iy, color cf, color hcf, String it) {
    index = ii;
    x = ix;
    y = iy;

    buttonFill = cf;
    hoverFill = hcf;
    
    buttonText = it;
  }

  void draw() {
    strokeWeight(1);
    if (lightsOn) {
      stroke(1);
    } else {
      stroke(255);
    }

    if (isClicked) {
      fill(color(128,128,128));
    } else if (hover) {
      fill(hoverFill);
    } else {
      fill(buttonFill);
    }
    rect(x, y, bWidth, bHeight);

    textAlign(CENTER);
    textSize(20);
    if (lightsOn) {
      fill(0);
    } else {
      fill(255);
    }
    text(buttonText, (x+bWidth/2)-30, (y+bHeight/2)+6 );
  }

  void clicked() {
    if (isClicked) {
      isClicked = false;
    } else {
      isClicked = true;
    }
  }
}
