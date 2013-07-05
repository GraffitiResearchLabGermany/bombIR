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

Path s;

void setup() {
  //size(640, 360, P3D);
  size(displayWidth, displayHeight, P3D);
  frameRate(60);
  
  wall = loadImage("wallTexture.jpg");
  
  sprayCan = new SprayManager();

  sprayMap = loadImage("sprayMap.png");

  depthOffset = 0.0;
  offsetVel = 0.0005;

  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");  
  //pointShader.set("sharpness", 0.9);
  pointShader.set( "sprayMap", sprayMap );

  strokeCap(SQUARE);
  //background(0);
  image(wall,0,0);
}

void draw() {

  float animSpeed = 4;
  float animate = ((sin(radians(frameCount * animSpeed)) + 1.0) / 2.0);
  
  weight = animate * 100.0 + 100.0;
  
  colorMode(HSB);
  float hue = animate * 255;
  color col = color( hue, 255, 255 );
  colorMode(RGB);
  
  sprayCan.setColor(col);
  sprayCan.setWeight(weight);

  //println(weight);

  if (mousePressed) {
    if ( null!= sprayCan ) 
      sprayCan.newKnot( mouseX, mouseY, weight );
  }
  
  if ( null != sprayCan ) sprayCan.draw();
}

void mousePressed() {
  sprayCan.newStroke(mouseX, mouseY, weight);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    //background(0);
    image(wall,0,0);
    sprayCan.clearAll();
  }
  if (key == 's' || key == 'S') {
    saveFrame(); 
  }
}

