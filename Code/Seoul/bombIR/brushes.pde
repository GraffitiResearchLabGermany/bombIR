
//-----------------------------------------------------------------------------------------
// BRUSHES

 void brushModes() {
    
    // Current Colour
    pg.stroke(brushR, brushG, brushB, brushA);
    pg.fill(brushR, brushG, brushB, brushA);
    pg.strokeWeight(brushSize);
    pg.strokeJoin(ROUND);
    
    if(mouseY < height - menuHeight) {
      
      // BRUSH MODES
      
      if(brushMode == 1) { // CIRCLE
        pg.ellipse(drawX, drawY, brushSize, brushSize);
      }
      
      if (brushMode == 2) { // FWD SLASH
        pg.line(drawX + brushSize, drawY - brushSize, drawX - brushSize, drawY + brushSize);
      }
      
      if (brushMode == 3) { // GHETTO PAINT
                            // from http://www.openprocessing.org/visuals/?visualID=2369
                            // by USER http://www.openprocessing.org/portal/?userID=1641
        for(int i = 0; i < 15; i++) {
          float theta = random(0, 4 * PI);
          int radius = int(random(0, 30));
          int x = int(drawX) + int(cos(theta)*radius);
          int y = int(drawY) + int(sin(theta)*radius);
          //pg.ellipse(x,y,0.5,0.5);
          pg.point(x,y);
        }
      }
    
      if(brushMode == 4) { // ERASER
          color c = color(0,0);
          pg.beginDraw();
          pg.loadPixels();
          for (int x = 0; x < pg.width; x++) {
            for (int y = 0; y < pg.height; y++ ) {
              float distance = dist(x, y, drawX, drawY);
              if (distance <= brushSize) {
                int loc = x + y * pg.width;
                pg.pixels[loc] = c;
              }
            }
          }
          pg.updatePixels();
          pg.endDraw(); 
      }
      
    }
  }
  
  //-----------------------------------------------------------------------------------------
  

