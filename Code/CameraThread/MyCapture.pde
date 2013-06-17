
 
 /* mycapture class provides the web camera image to other classes on demand */

import codeanticode.gsvideo.*;
import monclubelec.javacvPro.*; 
import java.awt.*;

public class MyCapture {

  public GSCapture cam;
  public int _w;
  public int _h;
  public PImage _img;
  public PApplet pa;


  public MyCapture (PApplet parent, int w, int h, int d) {
    _w = w;
    _h = h; 
    pa = parent;
    cam = new GSCapture(pa, _w, _h);
    
  }
  
  public void start() {
    cam.start();  
  }
  
  public PImage get_image(){
    cam.read();
    PImage tmp = cam.get();
    tmp.filter(PApplet.GRAY);
    return tmp;
  }
  
  public PImage readPixels() {
    cam.read();
    PImage rp = cam.get();
    return rp;
  }
  
  public boolean available() {
     return cam.available();
  }
  
  public void stop() {
    cam.stop();
  }
  
}
