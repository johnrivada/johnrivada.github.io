class Bonus {
  float x;
  float y;
  
  float width = 10;
  float height = 10;
  
  Bonus(float ix, float iy) {
    x = ix-(width/2);
    y = iy-(height/2);
  }
  
  void draw() {
    fill(234, 124, 23);
    ellipse(x,y, 10, 10);
  }
  
  void process() {
    x -= xSpeed;
  }
}
  
