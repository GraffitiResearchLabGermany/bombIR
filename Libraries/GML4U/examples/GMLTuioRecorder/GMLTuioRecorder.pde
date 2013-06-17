/**
* GML4U library
* Author Jerome Saint-Clair
* http://saint-clair.net
*
* This example shows how to use the GmlRecorder to record 
* and save GML from TUIO events
*
* Requirements:
* 
* You'll need the TUIO  Processing library to run this sketch
* http://www.tuio.org/?processing
* More info about TUIO here: http://www.tuio.org
*
* If you're on MacBook, I recommend you to use TongSeng as a TUIO
* client. It will transform your mousePad into a multitouch TUIO device.
* http://github.com/fajran/tongseng
*
*/

import org.apache.log4j.PropertyConfigurator;

import processing.opengl.*;

import TUIO.*;

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
int startTime = 0;

public TuioProcessing tuioClient;

void setup() {
  size(800, 600, OPENGL);
  PropertyConfigurator.configure(sketchPath+"/log4j.properties");

  // TUIO Client, listening on port 3333
  tuioClient = new TuioProcessing(this, 3333);

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
}



void draw() {
  background(255);

  // OpenGL camera & lights
  camera(screen.x/2, screen.y/3, screen.z*5, screen.x/2, screen.y/2, -screen.z/2, 0, 1, 0);
  lights();

  /*
  Here, we use the strokes handled by the recorder rather than
  the Gml returned by the recorder because we also want to see the 
  strokes
  while we draw them.
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
     Gml gml = recorder.getGml();
    for (GmlStroke strok : gml.getStrokes()) {
     float nPoints = strok.getPoints().size();
     float step = 1/nPoints;
     for (int i=0; i<nPoints; i++) {
      strok.getPoints().get(i).z = i*step;
     } 
    }
    recorder.clear();
    
    saver.save(gml, sketchPath+"/gml.gml");
  }
  else if (key == 'l' || key == 'L') {
    parser.parse(sketchPath+"/gml.gml", false);
  }
  else if (key == ' ') {
    recorder.clear();
  }
}


/*
 * TUIO EVENTS 
 */	

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  GmlBrush brush = new GmlBrush();
  brush.set(GmlBrush.UNIQUE_STYLE_ID, MeshDemo.ID);
  recorder.beginStroke(tobj.getSymbolID(), 0, brush);
  startTime = frameCount;
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {	
  // Get pointer coords
  Vec3D v = new Vec3D(tobj.getX(), tobj.getY(), startTime/300);
  recorder.addPoint(tobj.getSymbolID(), v, frameCount-startTime);
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
    recorder.endStroke(tobj.getSymbolID());
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  GmlBrush brush = new GmlBrush();
  brush.set(GmlBrush.UNIQUE_STYLE_ID, MeshDemo.ID);
  recorder.beginStroke((int) tcur.getSessionID(), 0, brush);
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  // Get pointer coords
  Vec3D v = new Vec3D(tcur.getX(), tcur.getY(), 0);
  recorder.addPoint((int) tcur.getSessionID(), v, 0);
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  recorder.endStroke((int) tcur.getSessionID());
}

// called after each message bundle
// representing the end of an image frame
void refresh(TuioTime bundleTime) {
	// Do nothing
}
