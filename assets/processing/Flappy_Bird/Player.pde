class Player {
  float x;
  float y;
  
  float accY;
  float velY;
  float size;
  
  float velLimit = 10;
  
  Player(float a, float b) {
    x = a;
    y = b;
    
    velY = 9;
    size = 50;
  }
  
  void process() {
    accY += gravity;
    
    velY += accY;
    
    if(velY > velLimit) {
      velY = velLimit;
    }
    
    if (velY < (velLimit*-1)) {
      velY = (velLimit*-1);
    }
    
    y += velY;
    
    if(y > (windowHeight-(size/2))) {
      y = (windowHeight-(size/2));
      velY = 0;
    } else if(y < 0) {
      y = 0;
      velY = 0;
    }
    
    accY = 0;
  }
  
  void draw() {
    fill(255,255,0);
    ellipse(x, y, size, size);
  }
  
  void flap() {
    accY -= 20;
  }
}
