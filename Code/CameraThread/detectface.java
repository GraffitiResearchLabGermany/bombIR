/**
 *  Copyright notice
 *  
 *  This file is part of the Processing sketch `You_Are_Einstein' 
 *  http://www.gwoptics.org/processing/
 *  
 *  Copyright (C) 2010 onwards Andreas Freise
 *  
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, 
 *  MA  02110-1301, USA.
 */

/* detectface runs the OpenCV face detection in a separate thread */

import processing.core.PImage;
import hypermedia.video.*;
import java.awt.Rectangle;
import processing.core.PApplet;
import processing.core.PConstants;

public class detectface extends Thread {

  private mycapture _cap;
  private boolean running;          
  private int wait;                  
  private OpenCV opencv;
  private int _w;
  private int _h;
  private int _w1;
  private int _h1;
  private PApplet parent;
  private Rectangle[] faces= new Rectangle[0];
  private PImage _img;

  public detectface (PApplet pa, mycapture cap, int wt, int w, int h, int w1, int h1) {
    parent=pa; 
    wait = wt;
    running = false;
    _w=w;
    _h=h;
    _w1=w1;
    _h1=h1;
    _cap=cap;
  }

  public void start ()
  {
    running = true;
    opencv = new OpenCV(parent);
    opencv.allocate(_w1,_h1);
    opencv.cascade(OpenCV.CASCADE_FRONTALFACE_ALT);
    super.start();
  }

  public Rectangle[] getRectangles() {
    return faces;
  }

  public void run ()
  {
    while (running) {
      _img=_cap.get_image();
      opencv.copy(_img,0, 0,_w,_h,0,0,_w1,_h1);
      //faces = opencv.detect(1.1f,4,OpenCV.HAAR_DO_CANNY_PRUNING,10,10);
      faces = opencv.detect(1.1f,4,0,10,10);
      try {
        sleep((long)(wait));
      }
      catch (Exception e) {}
    }
  }

  public void display() {
    parent.pushStyle();
    parent.tint(255);
    parent.image(_img, -_w, 0);
    parent.popStyle();
  }

  public void quit()
  {
    running = false;   
    interrupt(); 
    // Now sleep a while to avoid memeory errors 
    try {
      sleep(100l);
    } 
    catch (Exception e) {}
    opencv.stop();
  }
}

