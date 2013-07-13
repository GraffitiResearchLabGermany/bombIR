// http://glsl.heroku.com/e#4633.5

// Wall texture from: http://texturez.com/textures/concrete/4092

boolean debug = false;

SprayManager sprayCan;

PShader pointShader;

// Spray density distribution expressed in grayscale gradient
PImage sprayMap;

float weight;

float depthOffset;
float offsetVel;

PImage wall;

PGraphics paintscreen;

Path s;

void setup() {
  //size(640, , P3D);
  size(displayWidth, displayHeight, P3D);
  frameRate(60);
  
  paintscreen = createGraphics(width, height, P3D);
  
  wall = loadImage("wallTexture.jpg");
  
  sprayCan = new SprayManager();

  sprayMap = loadImage("sprayMap.png");

  depthOffset = 0.0;
  offsetVel = 0.0005;

  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");  
  //pointShader.set("sharpness", 0.9);
  pointShader.set( "sprayMap", sprayMap );

  //background(0);
  
  paintscreen.beginDraw();
  paintscreen.image(wall,0,0);
  paintscreen.endDraw();

}

void draw() {

  float animSpeed = 4;
  float animate = ((sin(radians(frameCount * animSpeed)) + 1.0) / 2.0);
  
  weight = animate * 100.0 + 100.0 + random(-10,10);
  
  colorMode(HSB);
  float hue = animate * 50;
  color col = color( hue, 255, 200 );
  colorMode(RGB);
  
  sprayCan.setColor(col);
  sprayCan.setWeight(weight);

  //println(weight);

  if (mousePressed) {
    if ( null!= sprayCan ) 
      sprayCan.newKnot( mouseX, mouseY, weight );
  }
  
  paintscreen.beginDraw();
  paintscreen.strokeCap(SQUARE);
  if ( null != sprayCan ) sprayCan.draw(paintscreen);
  paintscreen.endDraw();
  
  image(paintscreen,0,0);
}

void mousePressed() {
  sprayCan.newStroke(mouseX, mouseY, weight);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {

    paintscreen.beginDraw();
    paintscreen.image(wall,0,0);
    paintscreen.endDraw();
    
    sprayCan.clearAll();
  }
  if (key == 's' || key == 'S') {
    saveFrame(); 
  }
}

