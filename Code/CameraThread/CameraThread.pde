
import codeanticode.gsvideo.*;
import monclubelec.javacvPro.*; 
import java.awt.*;

// frame rate for sketch
final static float fps=100;

public MyCapture cap;
DetectFace detect;

// size (resolution) of image capture and screen
int w = 640;
int h = 480;
int w1 = 320;
int h1 = 240;
float factor = 2; 


void setup() {
  size(w,h);
  frameRate(fps);

  // init video capture
  cap = new MyCapture(this, w, h, 9);

  //  start face detection thread
  detect = new DetectFace(this, cap, 50, w, h, w1, h1);
  detect.start();

}

void draw() {
  background(0);

  //image(cap.get_image(), 0, 0);
  
  // flip image horizonatlly
  //pushMatrix();
    //scale(-1,1);
    detect.display();
  //popMatrix(); 

  println(frameRate);
}

public void stop() {
  detect.quit();
  delay(2000);
  cap.stop();
  super.stop();
}

