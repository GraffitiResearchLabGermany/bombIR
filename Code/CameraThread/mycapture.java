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
 
 /* mycapture class provides the web camera image to other classes on demand */

import processing.core.PImage;
import processing.core.PApplet;
import processing.core.PConstants;
import processing.video.*;


public class mycapture {

  public Capture cam;
  public int _w;
  public int _h;
  public PImage _img;


  public mycapture (PApplet pa, int w, int h, int d) {
    _w = w;
    _h = h;
    String[] devices = Capture.list();
    cam = new Capture(pa,_w,_h, devices[d]);  
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
  
  public void stop() {
    cam.stop();
  }
  
}
