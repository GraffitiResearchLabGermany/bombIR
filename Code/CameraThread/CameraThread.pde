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


/*
 * you_are_einstein displays the web camera stream as a virtual mirror
 * in which all frontal faces are replaced by pictures of Einstein.
 * 
 * Note: To run this, you need to install the OpenCV framework on 
 * your computer, see for example installation instructions here:
 * http://ubaa.net/shared/processing/opencv/
 *
 */

import hypermedia.video.*;
import java.awt.Rectangle;
//import fullscreen.*; 
import processing.video.*;


// frame rate for sketch, 100 works on my machine but you might need to
// lower this value
final static float fps=100;

public mycapture cap;
boolean pictureJustTaken = false;
int startTimer;
final static int interval = 20; // interval between pictures [s]
final static int interval2 = 4; // interval for 'blink' [s]
final static float print_wait=2000;
final static float photo_wait=500;
float timer1=0;
float timer2=0;

boolean take_snapshot = false;
PImage Emask;

// size (resolution) of image capture and screen
final static int w=640;
final static int h=480;
// size (resolution) of face detection buffer
final static int w1=320;
final static int h1=240;
final static float factor=2; // scaling between w/w1, h/h1


final static float max_blur=3;
final static int max_blur_img=20;

//FullScreen fs;
detectface detectthread;
PImage[] blurM=new PImage[max_blur_img];

void setup() {
  size(w,h);

  frameRate(fps);

  // init fullscreen mode
  //fs = new FullScreen(this);   
  //fs.enter(); 

  // init video capture
  cap=new mycapture(this,w,h, 9);

  //  start face detection thread
  detectthread= new detectface(this,cap,50,w,h,w1,h1);
  detectthread.start();

  Emask = loadImage("einstein_mask.png");
  create_blur(Emask);
  timer1=millis();
  timer2=millis();
}

void draw() {
  background(0);

  // flip image horizonatlly
  pushMatrix();
  scale(-1,1);
  detectthread.display();
  popMatrix(); 

  // get coordinates for detected faces
  Rectangle[] faces =  detectthread.getRectangles();

  if (millis()-timer1>print_wait) {
    // print framerate here to test speed
    //println(frameRate);
    timer1=millis();
  }

  // replace faces 
  for( int i=0; i<faces.length; i++ ) {
    float fh=faces[i].height;
    float fw=faces[i].width;
    float xoffset=0.92*fw;
    float yoffset=0.92*fh;
    float xoffset2=-0.1*fw;    
    float yoffset2=0.35*fh;
    float Iheight=factor*fh+2*xoffset;
    float Iwidth=factor*Emask.width*fh/Emask.height+2*yoffset;
    float fx=w+xoffset2+xoffset-factor*faces[i].x-Iwidth; 
    float fy=-yoffset2-yoffset+factor*faces[i].y+0.0*Iheight;
    float depth_factor=min(max(0,0.6*(Emask.height/Iheight)-1.0),1);
    int tint_factor=int(240-depth_factor*60);
    int blur_idx=floor((max_blur_img-1)*depth_factor);

    pushStyle();
    tint(tint_factor);
    image(blurM[blur_idx], fx,fy,Iwidth, Iheight);
    popStyle();
  }

  // take picture and save it
  if ((take_snapshot) && (pictureJustTaken == false)) {
    take_picture();
  }

  // draw 'blink' circle into upper right corner
  int ell_size=20;
  if (pictureJustTaken) {
    pushMatrix();
    if (millis() - startTimer > (interval2 * 1000)) {
      fill(128,128,128);
      stroke(128,128,128);
    }
    else
    {
      fill(255,255,255);
      stroke(255,255,255);
    }  
    ellipse(w-ell_size,ell_size,ell_size,ell_size);
    popMatrix();
    if (millis() - timer2 > photo_wait) {
      pictureJustTaken = false;
      timer2=millis();
    }
  }
  else
  {
    pushMatrix();
    fill(255,0,0);
    stroke(255,0,0);
    ellipse(w-ell_size,ell_size,ell_size,ell_size);
    popMatrix();
  }
}

public void create_blur(PImage Emask) {
  for (int i=0; i<blurM.length; i++) {
    float blur_factor=max_blur*pow(i/blurM.length,2);  
    blurM[i]= new PImage(Emask.width,Emask.height,ARGB);
    blurM[i].copy(Emask,0,0,Emask.width,Emask.height,0,0,Emask.width,Emask.height);  
    blurM[i].filter(BLUR,blur_factor);
  }
}

public void take_picture() {
  String filename="new/faces_"+year() + "-" + nf(month(),2) + "-"  + nf(day(),2) + "_"  + nf(hour(),2) + "-"  + nf(minute(),2) + "-"  + nf(second(),2);
  saveFrame(filename+".jpg");
  pictureJustTaken = true;
  println("taken photo");
  startTimer = millis();
  take_snapshot=false;
}

public void keyPressed() {		
  if(key == ' ') {
    take_snapshot=true;
  }
}

public void stop() {
  detectthread.quit();
  delay(2000);
  cap.stop();
  super.stop();
}

