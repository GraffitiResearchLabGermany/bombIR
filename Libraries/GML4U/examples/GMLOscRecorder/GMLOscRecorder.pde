/**
* GML4U library
* Author Jerome Saint-Clair
* http://saint-clair.net
*
* This example shows how to use the GmlRecorder to record 
* and save GML from OSC events
*
* Requirements:
* 
* You'll need oscP5  Processing library to run this sketch
* http://www.sojamo.de/libraries/oscP5/
*
* This sketch is configured to use TouchOSC which runs on
* Android and iOS as well. It uses the 3rd tab of the Simple
* layout which comes by default with TouchOSC.
* Hit any of the toggle buttons to start/stop recording of a stroke.
* Use the xy pad to draw.
* http://hexler.net/touchosc
*/

import org.apache.log4j.PropertyConfigurator;

import oscP5.*;
import netP5.*;

import gml4u.brushes.MeshDemo;
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

float gmlScale;
GmlRecorder recorder;
GmlParser parser;
GmlSaver saver;
GmlBrushManager brushManager;
Vec3D screen;

OscP5 oscP5;
boolean isRecording;


void setup() {
  size(800, 600, P3D);
  //xyRatio = height/width;
  PropertyConfigurator.configure(sketchPath+"/log4j.properties");

  // OSC Client, listening on port 3333
  oscP5 = new OscP5(this, 3333);


  // The recording area
  screen = new Vec3D(width, height, 100);
  
  // Recorder
  recorder = new GmlRecorder(screen, 0.015f, 0.01f);
  
  // BrushManager: used to draw
  brushManager = new GmlBrushManager();
  // Scale: used to scale back the Gml points to their original size
  gmlScale = width;

  // GmlParser to load a Gml file
  parser = new GmlParser(500, "", this);

  // GmlSaver to save a Gml
  saver = new GmlSaver(500, "", this);
  
  // Start recording by default
  GmlBrush brush = new GmlBrush();
  brush.set(GmlBrush.UNIQUE_STYLE_ID, MeshDemo.ID);
  recorder.beginStroke(0, 0, brush);
  isRecording = true;

  
}



void draw() {
  background(255);

  stroke(0, 30);
  fill(0, 30);

  /*
  Here, we use the strokes handled by the recorder rather than
  the Gml returned by the recorder because we also want to see the 
  strokes while we draw them.
  */
  for (GmlStroke gmlStroke : recorder.getStrokes()) { 
	brushManager.draw(g, gmlStroke, gmlScale);
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


/*
 * OSC EVENTS 
 */	

// called when an OSC event is received
void oscEvent(OscMessage message) {

  // Events below are mapped for TouchOSC, Simple layout, 3rd tab
  // Use any of the toggle buttons to start/stop stroke recording

  String addr = message.addrPattern();
  
  // If toggle buttons, then switch recording on/off
  if (addr.indexOf("/3/toggle") >= 0) {
    if (!isRecording) {
      // Start recording a new stroke
      GmlBrush brush = new GmlBrush();
      brush.set(GmlBrush.UNIQUE_STYLE_ID, MeshDemo.ID);
      recorder.beginStroke(0, 0, brush);
      isRecording = true;
    }
    else {
      // Stop recording stroke
      recorder.endStroke(0);
      isRecording = false;
    }
    
  }
  // Record points
  else if (isRecording && addr.equals("/3/xy")) {
    // Get pointer coords
    float x = message.get(0).floatValue();
    float y = message.get(1).floatValue();
    Vec3D v = new Vec3D(x, y, 0);
    recorder.addPoint(0, v, 0);
  }
}
