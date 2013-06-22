ControlP5 menu;
int cpsize = 200;
int picker;
float brushR, brushG, brushB;
int activeColorSlot=0;
ColorSlotCanvas cs;
RadioButton rb;


//setup the control menu
void setupMenu(){
    menu = new ControlP5(this);
    
    cs = (ColorSlotCanvas)menu.addGroup("cs")
                .setPosition(cpsize+50,80)
                .setBackgroundHeight(cpsize+1)
                .setWidth(90)
                .setBackgroundColor(color(0))
                .hideBar()
                .addCanvas(new ColorSlotCanvas())
                ;
                
    
    menu.addGroup("misc")
                .setPosition(50,280)
                .setBackgroundHeight(50)
                .setWidth(cpsize+90)
                .setBackgroundColor(color(0))
                .hideBar()
                ;
    menu.addGroup("width")
                  .setPosition(50,51)
                  .setBackgroundHeight(30)
                  .setWidth(cpsize+90)
                  .setBackgroundColor(color(0))
                  .hideBar()
                  ;
    //TODO: Pickable colors change when something has been drawn in the back 
    //of the colorpicker    
    menu.addGroup("cp")
                        .setPosition(50,80)
                        .setBackgroundHeight(cpsize)
                        .setWidth(cpsize)
                        .setBackgroundColor(color(255))
                        .hideBar()
                        .addCanvas(new ColorPickerCanvas());
                        
    menu.addSlider("WIDTH", 1, 200, 100, 5, 5, cpsize, 20).setGroup("width");
    menu.addBang("CLEAR", 10, 10, 20, 20).setGroup("misc");
    menu.addBang("SAVE",  40, 10, 20, 20).setGroup("misc");
    
    rb = menu.addRadioButton("radioButton")
         .setPosition(280,80)
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
     rb.activate(0);
    
    menu.hide();
}


//draw the colorslots 
void drawColorSlots(){   
    if(mouseX > 50 && mouseX < cpsize + 50 && mouseY > 80 && mouseY < 280) {
          if(mousePressed) {
            picker = get(mouseX, mouseY);
            brushR = red(picker);
            brushG = green(picker);
            brushB = blue(picker);
            cs.setColorSlot(activeColorSlot,brushR,brushG,brushB);
          } 
     }  
} 

//is called when a radio button is pressed
void radioButton(int a) {
  activeColorSlot = a;  
}

void switchColorSlot(){
  activeColorSlot = cs.getNextColorSlot(activeColorSlot);
  rb.activate(activeColorSlot);
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

/**
 * Canvas to draw the color picker
 * TODO: remove references to cpsize
 */
class ColorPickerCanvas extends Canvas {
  
  PGraphics colorpicker;
  
  public void setup(PApplet p) {
    this.createColorPicker(p);
  }
  
  public void draw(PApplet p) {
    p.image(colorpicker,0,0);
  }
  
  //create the colorpicker once
  protected void createColorPicker(PApplet p){
   this.colorpicker = createGraphics(cpsize, cpsize, JAVA2D);
   this.colorpicker.background(255);
   // Colour Picker
   this.colorpicker.beginDraw();
   this.colorpicker.colorMode(HSB, cpsize);
   for (int i = 0; i < cpsize; i++) {
     for (int j = 0; j < cpsize; j++) {
       this.colorpicker.stroke(i, j, i+j);
       this.colorpicker.point(i, j);
     }
   }
   this.colorpicker.endDraw();
   this.colorpicker.colorMode(RGB);
  }
}

class ColorSlotCanvas extends Canvas {
  ColorSlot[] colorSlots = new ColorSlot[5];
  
  public void setup(PApplet p) {
    colorSlots[0] = new ColorSlot(5,0);
    colorSlots[1] = new ColorSlot(5,21);
    colorSlots[2] = new ColorSlot(5,42);
    colorSlots[3] = new ColorSlot(5,63);
    colorSlots[4] = new ColorSlot(5,84);
  }
  
   public void draw(PApplet p) {
    for(int i=0;i<=4;i++){
        this.colorSlots[i].draw(p);
    }
  }
  
  //update the color of the color slot
  public void setColorSlot(int activeSlot, float red, float green, float blue){
    this.colorSlots[activeSlot].setRed(red);
    this.colorSlots[activeSlot].setGreen(green);
    this.colorSlots[activeSlot].setBlue(blue); 
  }
  
  public int getNextColorSlot(int activeSlot){
    if(activeSlot < this.colorSlots.length-1) {
      return activeSlot+1;
    } 
    return 0;
  }
  
  public ColorSlot getColorSlot(int id){
    return this.colorSlots[id];
  }

}


  
