/**
* GML4U library
* Author Jerome Saint-Clair
* http://saint-clair.net
*
* This example shows how to iterate through GML strokes
* and points to draw GML with your own custom style
*
*/


import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh2d.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh.*;
import toxi.math.waves.*;
import toxi.util.*;
import toxi.math.noise.*;

import org.apache.log4j.PropertyConfigurator;

import gml4u.brushes.*;
import gml4u.drawing.*;
import gml4u.utils.*;
import gml4u.utils.Timer;
import gml4u.model.*;

Gml gml;
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
    for (GmlStroke strok : gml.getStrokes()) {
      for (GmlPoint p : strok.getPoints()) {
        if (p.time > timer.getTime()) {
         continue; 
        }
          Vec3D v = new Vec3D(p);
          v.scaleSelf(width);
          fill(random(255), random(255), random(255));
          ellipse(v.x, v.y, random(10,20), random(10, 20));
      }
    }
}
