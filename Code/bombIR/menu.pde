
ControlP5 menu;
PGraphics colorpicker;
int cpsize = 200;
int picker;
float brushR, brushG, brushB;
int activeColorSlot=0;

ColorSlot[] colorSlots = new ColorSlot[5];

//setup the control menu
void setupMenu(){
    menu = new ControlP5(this);
    
    /*Group all = menu.addGroup("right")
                .setPosition(cpsize+50,80)
                .setBackgroundHeight(cpsize+1)
                .setWidth(50)
                .setBackgroundColor(color(0))
                .hideBar()
                ;*/
                
    
    Group misc = menu.addGroup("misc")
                .setPosition(50,280)
                .setBackgroundHeight(50)
                .setWidth(cpsize+50)
                .setBackgroundColor(color(0))
                .hideBar()
                ;
    Group width = menu.addGroup("width")
                  .setPosition(50,51)
                  .setBackgroundHeight(30)
                  .setWidth(cpsize+50)
                  .setBackgroundColor(color(0))
                  .hideBar()
                  ;
                
    //TODO Add the colopicker to the menu
    /*Group colorpicker = menu.addGroup("cp").
                        .setPosition(50,80)
                        .setBackgroundHeight(cpsize)
                        .setWidth(cpsize)
                        .setBackgroundColor(color(0))
                        .hideBar()
                        .addCanvas(cpCanvas);*/
                        
    menu.addSlider("WIDTH", 1, 200, 100, 5, 5, cpsize, 20).setGroup("width");
    menu.addBang("CLEAR", 10, 10, 20, 20).setGroup("misc");
    menu.addBang("SAVE",  40, 10, 20, 20).setGroup("misc");
    
    menu.addRadioButton("radioButton")
         .setPosition(300,80)
         .setSize(20,20)
         .setColorForeground(color(120))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setItemsPerRow(1)
         .setSpacingColumn(50)
         .addItem("Color1",0)
         .addItem("Color2",1)
         .addItem("Color3",2)
         .addItem("Color4",3)
         .addItem("Color5",4)
         ;
    
    createColorPicker();
    menu.hide();
    
   
    colorSlots[0] = new ColorSlot(cpsize + 60,80);
    colorSlots[1] = new ColorSlot(cpsize + 60,101);
    colorSlots[2] = new ColorSlot(cpsize + 60,122);
    colorSlots[3] = new ColorSlot(cpsize + 60,143);
    colorSlots[4] = new ColorSlot(cpsize + 60,164);
    
   
}

//create the colorpicker once
void createColorPicker(){
   colorpicker = createGraphics(cpsize, cpsize, JAVA2D); 
   // Colour Picker
   colorpicker.beginDraw();
   colorpicker.colorMode(HSB, cpsize);
   for (int i = 0; i < cpsize; i++) {
     for (int j = 0; j < cpsize; j++) {
       colorpicker.stroke(i, j, i+j);
       colorpicker.point(i, j);
     }
   }
   colorpicker.endDraw();
   colorMode(RGB);
}

//draw the colorpicker whenever the menue's called  
void drawColorPicker(){
  image(colorpicker,50,80);
  
  if(menu.isVisible()){
     for(int i=0;i<=4;i++){
        colorSlots[i].draw(this);
      }
    
    if(mouseX > 50 && mouseX < cpsize + 50 && mouseY > 80 && mouseY < 280) {
          if(mousePressed) {
            picker = get(mouseX, mouseY);
            brushR = red(picker);
            brushG = green(picker);
            brushB = blue(picker);
            setColorSlot(activeColorSlot,brushR,brushG,brushB);
          } 
        }  
  }
} 

//is called when a radio button is pressed
void radioButton(int a) {
  activeColorSlot = a;  
}

//update the color of the color slot
void setColorSlot(int activeSlot, float red, float green, float blue){
  colorSlots[activeSlot].setRed(red);
  colorSlots[activeSlot].setGreen(green);
  colorSlots[activeSlot].setBlue(blue); 
  colorSlots[activeSlot].draw(this);
}

/**
 * Slot to save picked colors for later use
 */
class ColorSlot{
  
  protected float red=0.0;
  protected float green=0.0;
  protected float blue=0.0;
  
  protected int positionX;
  protected int positionY;
 
  public ColorSlot(int positionX, int positionY){
    this.positionX = positionX;
    this.positionY = positionY;
  }
  
  public void draw(PApplet applet){
    applet.fill(red, green, blue);
    applet.rect(this.positionX, this.positionY, 20, 20);
  }
  
  public float getRed(){
    return red;
  }
  
  public float getGreen(){
    return green;
  }
  
  public float getBlue(){
    return blue;
  }
  
  public void setRed(float red){
    this.red = red;
  }
  
  public void setGreen(float green){
   this.green = green; 
  }
  
  public void setBlue(float blue){
    this.blue = blue;
  }
}


  
