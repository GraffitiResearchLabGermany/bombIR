/**
* GML4U library
* Author Jerome Saint-Clair
* http://saint-clair.net
*
* This example shows how to use a timer to draw GML 
* back and forth based on the GML's time information 
*
*/

import org.apache.log4j.PropertyConfigurator;

import gml4u.brushes.*;
import gml4u.drawing.*;
import gml4u.utils.*;
import gml4u.utils.Timer;
import gml4u.model.*;

Gml gml;
GmlBrushManager brushManager = new GmlBrushManager(this);
Timer timer = new Timer();
int timeMax = 30;

void setup() {
  size(600, 400, P3D);
  PropertyConfigurator.configure(sketchPath+"/log4j.properties");
   
  gml = GmlParsingHelper.getGml(sketchPath+"/sample.gml.xml", false);
  
  GmlUtils.timeBox(gml, timeMax, true);
  timer.start();
}

void draw() {
    background(0);
    timer.tick();
     // If one reach the begining or the end, then invert the direction of the timer
    if (timer.getTime() > timeMax || timer.getTime() < 0) {
     timer.invert();
    }
    brushManager.draw(gml, width, timer.getTime());
}