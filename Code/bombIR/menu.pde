
//-----------------------------------------------------------------------------------------
// GUI

ControlP5 menu;
int cpsize = 200;
int picker;
float brushR, brushG, brushB;
int activeColorSlot = 0;
ColorSlotCanvas cs;
RadioButton rb;
ColorPicker cp;


//setup the control menu
void setupMenu(){
    menu = new ControlP5(this);
    
    cp = new ColorPicker(50, 80, 200, 200, 45);
    
    cs = (ColorSlotCanvas)menu.addGroup("cs")
                .setPosition(cpsize + 50, 80)
                .setBackgroundHeight(cpsize + 1)
                .setWidth(90)
                .setBackgroundColor(color(0))
                .hideBar()
                .addCanvas(new ColorSlotCanvas())
                ;       
    
    menu.addGroup("misc")
                .setPosition(50, 280)
                .setBackgroundHeight(50)
                .setWidth(cpsize + 90)
                .setBackgroundColor(color(0))
                .hideBar()
                ;
    menu.addGroup("width")
                  .setPosition(50, 51)
                  .setBackgroundHeight(30)
                  .setWidth(cpsize + 90)
                  .setBackgroundColor(color(0))
                  .hideBar()
                  ;
     
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

// separate menu for calibration
ControlP5 calibMenu;

void setupCalibrationMenu() {
  // Init
  calibMenu = new ControlP5(this);
  // Scale
  calibMenu.addSlider("cropScale").setPosition(350, 51).setSize(200, 20).setRange(0, 10);
  // Blob Threshold
  calibMenu.addSlider("blobThresh").setPosition(350, 76).setSize(200, 20).setRange(0, 1);
  // Blob Min
  calibMenu.addSlider("blobMin").setPosition(350, 101).setSize(200, 20).setRange(0, 1);
  // Blob Max
  calibMenu.addSlider("blobMax").setPosition(350, 126).setSize(200, 20).setRange(0, 1);
  // Show Cam
  calibMenu.addToggle("showCam").setPosition(350, 151).setSize(40, 40);
  // Show Blobs
  calibMenu.addToggle("showBlob").setPosition(400, 151).setSize(40, 40);
  // Save Calibration
  calibMenu.addBang("saveCalib").setPosition(450, 151).setSize(40, 40);
  
  calibMenu.hide();
}


//pck color with the mouse
void pickColor(){   
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
  
  protected float red = 0.0;
  protected float green = 0.0;
  protected float blue = 0.0;
  
  protected int positionX;
  protected int positionY;
 
  public ColorSlot(int positionX, int positionY) {
    this.positionX = positionX;
    this.positionY = positionY;
  }
  
  public void draw(PApplet applet){
    applet.fill(red, green, blue);
    applet.rect(this.positionX, this.positionY, 20, 20);
  }
  
  public float getRed() {
    return red;
  }
  
  public float getGreen() {
    return green;
  }
  
  public float getBlue() {
    return blue;
  }
  
  public void setRed(float red) {
    this.red = red;
  }
  
  public void setGreen(float green) {
   this.green = green; 
  }
  
  public void setBlue(float blue) {
    this.blue = blue;
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
  public void setColorSlot(int activeSlot, float red, float green, float blue) {
    this.colorSlots[activeSlot].setRed(red);
    this.colorSlots[activeSlot].setGreen(green);
    this.colorSlots[activeSlot].setBlue(blue); 
  }
  
  public int getNextColorSlot(int activeSlot) {
    if(activeSlot < this.colorSlots.length-1) {
      return activeSlot+1;
    } 
    return 0;
  }
  
  public ColorSlot getColorSlot(int id){
    return this.colorSlots[id];
  }

}

/**
 * Colorpicker from http://www.julapy.com/processing/ColorPicker.pde
 * with little adjustments
 */
 
public class ColorPicker {
  int x, y, w, h, c;
  PImage cpImage;
  
  public ColorPicker ( int x, int y, int w, int h, int c ) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    
    cpImage = new PImage( w, h );
    
    init();
  }
  
  private void init () {
    // draw color.
    int cw = w - 60;
    for( int i=0; i<cw; i++ ) {
      float nColorPercent = i / (float)cw;
      float rad = (-360 * nColorPercent) * (PI / 180);
      int nR = (int)(cos(rad) * 127 + 128) << 16;
      int nG = (int)(cos(rad + 2 * PI / 3) * 127 + 128) << 8;
      int nB = (int)(Math.cos(rad + 4 * PI / 3) * 127 + 128);
      int nColor = nR | nG | nB;
      
      setGradient( i, 0, 1, h/2, 0xFFFFFF, nColor );
      setGradient( i, (h/2), 1, h/2, nColor, 0x000000 );
    }
    
    // draw black/white.
    drawRect( cw, 0,   30, h/2, 0xFFFFFF );
    drawRect( cw, h/2, 30, h/2, 0 );
    
    // draw grey scale.
    for( int j=0; j<h; j++ ) {
      int g = 255 - (int)(j/(float)(h-1) * 255 );
      drawRect( w-30, j, 30, 1, color( g, g, g ) );
    }
  }

  private void setGradient(int x, int y, float w, float h, int c1, int c2 ) {
    float deltaR = red(c2) - red(c1);
    float deltaG = green(c2) - green(c1);
    float deltaB = blue(c2) - blue(c1);

    for (int j = y; j<(y+h); j++) {
      int c = color( red(c1)+(j-y)*(deltaR/h), green(c1)+(j-y)*(deltaG/h), blue(c1)+(j-y)*(deltaB/h) );
      cpImage.set( x, j, c );
    }
  }
  
  private void drawRect( int rx, int ry, int rw, int rh, int rc ) {
    for(int i=rx; i<rx+rw; i++) {
      for(int j=ry; j<ry+rh; j++)  {
        cpImage.set( i, j, rc );
      }
    }
  }
  
  public void render () {
    image( cpImage, x, y );
  }
}


  
