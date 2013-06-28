
//-----------------------------------------------------------------------------------------

void gui() {

  background(0);
  
  // Color Picker
  image(cp, 0, height - cpSize * 1.1);
  
  // Buttons
  image(circle, 0,   height - cpSize * 1.1);
  image(chisel, 100, height - cpSize * 1.1);
  image(spray, 200,  height - cpSize * 1.1);
  image(drip, 300,   height - cpSize * 1.1);
  image(eraser, 600, height - cpSize * 1.1);

  // Circle  
  if(mouseX > 0  && mouseX < 100) {
    if(mousePressed) {      
      brush.set("uniqueStyleID", Circle.ID);
      brushMode = 1;
      brushPicked = 12;
    }
  }      
  
  // SLASH
  if(mouseX > 100  && mouseX < 200) {
    if(mousePressed) {   
      brush.set("uniqueStyleID", FwdSlash.ID);
      brushMode = 2;
      brushPicked = 110;
    }
  } 
  
  // SPRAY
  if(mouseX > 200  && mouseX < 300) {
    if(mousePressed) {    
      brush.set("uniqueStyleID", GhettoPaint.ID);
      brushMode = 3;
      brushPicked = 210;
    }
  } 

  // DRIPS
  if(mouseX > 300  && mouseX < 400) {
    if(mousePressed) {    
      //dripsIO =! dripsIO;
      dripsIO = false;
      if(dripsIO == true)  dripsPicked = 255;
      if(dripsIO == false) dripsPicked = 0;
      
    }
  }    
  
  // PICKER
  if(mouseX > 475 - cpSize && mouseX < 475) {
    if(mousePressed) {     
      picker = get(int(mouseX), int(mouseY));
      brushR = red(picker);
      brush.set("red", ""+brushR);
      brushG = green(picker);
      brush.set("green", ""+brushG);
      brushB = blue(picker);
      brush.set("blue", ""+brushB);         
    }
  }
  pushStyle();
    fill(brushR, brushG, brushB);
    rect(575 - cpSize, height - cpSize * 1.1, cpSize, cpSize);
  popStyle();  

  // ERASER
  if(mouseX > 600  && mouseX < 700) {
    if(mousePressed) {    
      dripsIO = false;
      //brush.set("uniqueStyleID", Eraser.ID);
      brushMode = 4;
      brushPicked = 610;
    }
  } 

  // SIZE
  if(mouseX > 700  && mouseX < 950) {
    if(mousePressed) {    
      if(mouseX > 700  && mouseX < 720) {
        brushSize = 2;
        brush.set("size", "" + brushSize);
        sizePicked = 695;
      }
      else if(mouseX > 720  && mouseX < 745) {
        brushSize = 5;
        brush.set("size", "" + brushSize);
        sizePicked = 720;
      }
      else if(mouseX > 745  && mouseX < 785) {
        brushSize = 10;
        brush.set("size", "" + brushSize);
        sizePicked = 745;
      }
      else if(mouseX > 785  && mouseX < 835) {
        brushSize = 15;
        brush.set("size", "" + brushSize);
        sizePicked = 785;
      }
      else if(mouseX > 835  && mouseX < 895) {
        brushSize = 25;
        brush.set("size", "" + brushSize);
        sizePicked = 835;
      }
      else if(mouseX > 895  && mouseX < 920) {
        brushSize = 35;
        brush.set("size", "" + brushSize);
        sizePicked = 895;
      }      
    }
  } 
 
  // BRYSH SIZE
  pushStyle();
    smooth();
    fill(255);
    ellipse(700, height - 50, 2, 2);
    ellipse(725, height - 50, 5, 5);
    ellipse(750, height - 50, 10, 10);
    ellipse(790, height - 50, 15, 15);
    ellipse(840, height - 50, 25, 25);
    ellipse(900, height - 50, 35, 35);
  popStyle();
  
  // MARKERS
  pushStyle();
    smooth();
    strokeCap(ROUND);
    strokeWeight(4);
    stroke(255, 0, 0);
    // Brush Marker
    line(brushPicked, height - 15, brushPicked + 50, height - 15);
    // Size Marker
    line(sizePicked, height - 15, sizePicked + 10, height - 15);
    stroke(dripsPicked, 0, 0);
    // Drips Marker
    line(312, height - 15, 365, height - 15);
  popStyle();
  
  // Cursor
  if(DrawMode != 1) {
    if(showCursor == true) {
      image(circle, mouseX, mouseY, 15, 15); 
    } 
  }

}

//-----------------------------------------------------------------------------------------
