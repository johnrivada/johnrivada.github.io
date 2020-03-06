class Pipe {

  float width;
  float height;

  float topY;
  float bottomY;

  float x;

  boolean isTop;
  boolean hit;

  Pipe(boolean it, float h) {
    hit = false;
    width = 80;
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
