/**
* GML4U library
* Author Jerome Saint-Clair
* http://saint-clair.net
*
* This example shows the simplest way to load and
* draw a GML file
*
*/

import org.apache.log4j.PropertyConfigurator;

import gml4u.brushes.*;
import gml4u.drawing.*;
import gml4u.utils.*;
import gml4u.model.*;

Gml gml;
GmlBrushManager brushManager = new GmlBrushManager(this);

void setup() {
  size(600, 400, P3D);
  PropertyConfigurator.configure(sketchPath+"/log4j.properties");
   
  gml = GmlParsingHelper.getGml(sketchPath+"/sample.gml.xml", false);
}

void draw() {
    brushManager.draw(gml, 600);
}
