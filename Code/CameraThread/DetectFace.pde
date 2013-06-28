
/* detectface runs the OpenCV face detection in a separate thread */

import codeanticode.gsvideo.*;
import monclubelec.javacvPro.*; 
import java.awt.*;

public class DetectFace extends Thread {

  private MyCapture _cap;
  private boolean running;          
  private int wait;                  
  private OpenCV opencv;
  private int _w;
  private int _h;
  private int _w1;
  private int _h1;
  private PApplet parent;
  Rectangle[] faceRect; 
  private PImage _img;

  public DetectFace (PApplet pa, MyCapture cap, int wt, int w, int h, int w1, int h1) {
    wait = wt;
    running = false;
    _w = w;
    _h = h;
    _w1 = w1;
    _h1 = h1;
    _cap = cap;
  }

  public void start () {
    running = true;
    opencv = new OpenCV(parent);
    opencv.allocate(_w1,_h1);
    opencv.cascade("/usr/local/share/OpenCV/haarcascades/","haarcascade_frontalface_alt.xml"); 
    //_cap.start();
    super.start();
  }

  public void run() {
    while (running) {
      if (_cap.available() == true) {
        _img = _cap.get_image();
        //opencv.copy(_img);
        //faceRect = opencv.detect(true);
      }
      try {
        sleep((long)(wait));
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  }

  public void display() {
    //if (_cap.available() == true) {
      image(_cap.get_image(), 0, 0);
      //faceRect = opencv.detect(true);
      //println("Number of faces =" + faceRect.length + "."); 
      //opencv.drawRectDetect(true);
    //}
  }

  public void quit() {
    running = false;   
    interrupt(); 

    try {
      sleep((long)100);
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}

