class PipePair {
  float gap;
  float topHeight;
  float bottomHeight;

  Pipe bottomPipe;
  Pipe topPipe; 

  Bonus bonus;

  PipePair() {
    gap = 200;
    topHeight = random(20, windowHeight-100-gap);
    bottomHeight = windowHeight - topHeight - gap;
    
    topPipe = new Pipe(true, topHeight);
    bottomPipe = new Pipe(false, bottomHeight);
    
  }

  void process() {
    bottomPipe.process();
    topPipe.process();
  }

  void draw() {
    topPipe.draw();
    bottomPipe.draw();
  }

  boolean isOffScreen() {
    if (bottomPipe.x + bottomPipe.width < 0) {
      return true;
    }
    return false;
  }
}
