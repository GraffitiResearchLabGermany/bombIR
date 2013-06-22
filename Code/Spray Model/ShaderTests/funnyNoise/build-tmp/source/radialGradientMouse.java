import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class radialGradientMouse extends PApplet {

PShader sprayBrush;

public void setup() {

  size(512, 512, P2D);

  sprayBrush = loadShader("shader.glsl");

  sprayBrush.set( "resolution", PApplet.parseFloat(width), PApplet.parseFloat(height) );

}


public void draw() {

  background(255);
  
  sprayBrush.set( "mouse", PApplet.parseFloat(mouseX), PApplet.parseFloat(mouseY) );

  shader(sprayBrush);

  rect( 0, 0, width, height );  

  resetShader();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "radialGradientMouse" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
