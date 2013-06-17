/**
* GML4U library
* Author Jerome Saint-Clair
* http://saint-clair.net
*
* This example shows how to use the GmlRecorder to record 
* and save GML from mouse coordinates
*
*/

import org.apache.log4j.PropertyConfigurator;

import gml4u.brushes.CurvesDemo;
import gml4u.drawing.GmlBrushManager;
import gml4u.events.GmlEvent;
import gml4u.events.GmlParsingEvent;
import gml4u.model.GmlBrush;
import gml4u.model.GmlConstants;
import gml4u.model.GmlStroke;
import gml4u.model.Gml;
import gml4u.recording.GmlRecorder;
import gml4u.utils.GmlParser;
import gml4u.utils.GmlSaver;
import toxi.geom.Vec3D;

float scale;
GmlRecorder recorder;
GmlParser parser;
GmlSaver saver;
GmlBrushManager brushManager;

void setup() {
  size(800, 600, P2D);
  PropertyConfigurator.configure(sketchPath+"/log4j.properties");

  // The recording area
  Vec3D screen = new Vec3D(width, height, 100);
  
  // Recorder
  recorder = new GmlRecorder(screen, 0.015f, 0.01f);
  
  // BrushManager: used to draw
  brushManager = new GmlBrushManager(this);
  // Scale: used to scale back the Gml points to their original size
  scale = width;

  // GmlParser to load a Gml file
  parser = new GmlParser(500, "", this);
  parser.start();

  // GmlSaver to save a Gml
  saver = new GmlSaver(500, "", this);
  saver.start();
}



void draw() {
  background(255);

  stroke(0, 30);
  fill(0, 30);
  // Here, we use the strokes handled by the recorder rather than
  // the Gml returned by the recorder because we also want the strokes
  // being drawn
  for (GmlStroke stroke : recorder.getStrokes()) { 
	brushManager.draw(stroke, scale);
  }
}

// Callback method
void gmlEvent(GmlEvent event) {
  // Check if the event was sent by the parser 
  if (event instanceof GmlParsingEvent) {
    // If so, get the Gml
    Gml gml = ((GmlParsingEvent) event).gml;
    recorder.setGml(gml);
  }
}


void keyPressed() {

  if (key == 's' || key == 'S') {
    saver.save(recorder.getGml(), sketchPath+"/gml.xml");
  }
  else if (key == 'l' || key == 'L') {
    parser.parse(sketchPath+"/gml.xml", false);
  }
  else if (key == ' ') {
    recorder.clear();
  }
}


// Called when mouse buttons are pressed
void mousePressed() {
    // Start recording if not already
    GmlBrush brush = new GmlBrush();
    brush.set(GmlBrush.UNIQUE_STYLE_ID, CurvesDemo.ID);
    recorder.beginStroke(0, 0, brush);
}


// Called when mouse is moved with button pressed
void mouseDragged() {
    // Get pointer coords as a xyz Vector between 0,0,0 and 1,1,1
    Vec3D v = new Vec3D((float) mouseX/width, (float) mouseY/height, frameCount/3000);
    recorder.addPoint(0, v, frameCount/3000);
}

// Called when mouse buttons are released
void mouseReleased() {
    recorder.endStroke(0);
}