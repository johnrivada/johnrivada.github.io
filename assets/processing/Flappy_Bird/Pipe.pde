class Pipe {

  float width;
  float height;

  float topY;
  float bottomY;

  float x;

  boolean isTop;
  boolean hit;

  PImage img;
  PImage img2;
  Pipe(boolean it, float h) {
    hit = false;
    width = 50;
    height = h;
    x = windowWidth + width;
    isTop = it;

    if (isTop) {
      topY = 0;
      bottomY = height;
    } else {
      topY = windowHeight - height;
      bottomY = height;
    }

    img = loadImage("pipe.png");
    img2 = loadImage("pipe2.png");
  }

  void process() {
    x -= xSpeed;
  }

  void draw() {
    if (hit) {
      fill(204, 0, 0);
    } else {
      fill(0, 204, 0);
    }
    rect(x, topY, width, height);
    if (isTop) {
      image(img2, x-3, topY, 56, height);
    } else {
      image(img, x-3, topY, 56, height);
    }
  }

  boolean collided(Player p) {
    if ((p.x + (p.size/2) >= x) && (p.x - (p.size/2) <= x + width)) {
      if (!isTop && p.y + (p.size/2) >= topY) {
        hit = true;
        return true;
      }
      if (isTop && p.y - (p.size/2) < (topY+height)) {
        hit = true;
        return true;
      }
    }
    return false;
  }
}
