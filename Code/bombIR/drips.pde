
// From www.openprocessing.org
// by USER http://www.openprocessing.org/portal/?userID=1641
//-----------------------------------------------------------------------------------------

void drip() {
  
  if(numDrips < 999 && random(1) < .2) {
    drips[numDrips] = new Drop(mouseX, mouseY, brushR, brushG, brushB);
    numDrips++;
  } 
  
}

//---

class Drop {
  
  int x, y, size,r,red,green,blue;
  boolean isMoving;
  color c;
  
  Drop(int theX, int theY, float _brushR, float _brushG, float _brushB) {
    x = theX;
    y = theY;
    c = color(_brushR, _brushG, _brushB);
    r = int(random(399,600));
    size = 5;
    isMoving = true;
  }
  
  void drip(){
    if(size > 1 && random(1) < .3) {
      size--;
    }
    if(isMoving == true){
      if(frameCount % 4 == 1) {
        y++;
      }
    }
  }
  
  void stopping(){
    if(int(random(100)) == 0){
      isMoving = false;
    }
  }
  
  void show(){
    pg.fill(c);
    pg.stroke(c);
    pg.strokeWeight(2);
    pg.strokeCap(ROUND);
    pg.strokeJoin(ROUND);
    pg.ellipse(x, y, size, size);
  }
  
}

//-----------------------------------------------------------------------------------------

