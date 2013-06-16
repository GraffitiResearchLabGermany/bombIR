/**
* GML4U library
* Author Jerome Saint-Clair
* http://saint-clair.net
*
* This sketch lists the various methods used to load and save Gml files
*
*/


import org.apache.log4j.PropertyConfigurator;

import gml4u.brushes.*;
import gml4u.recording.*;
import gml4u.utils.*;
import gml4u.drawing.*;
import gml4u.events.*;
import gml4u.model.*;

// Declare a Gml object and GmlMultiParser
ArrayList<Gml> gmls = new ArrayList<Gml>();
// Current Gml pointer
int current = 0;

// Declare a Gml parser and a Gml saver
GmlParser parser;
GmlSaver saver;

// Declare a GmlBrushManager (used to draw)
GmlBrushManager brushManager = new GmlBrushManager(this);

void setup() {
  size(600, 400, P2D);
  smooth();
  textAlign(CENTER, CENTER);
  
  // GML4U configuration (set Logging level)
  PropertyConfigurator.configure(sketchPath+"/log4j.properties");
  
  // Create and start the thread with a 500ms waiting time, a name and a reference to your sketch (this)
  parser = new GmlParser(500, "GmlParser", this);
  saver = new GmlSaver(500, "GmlSaver", this);

  // NOTE you can comment / uncomment the lines below to test the different parsing methods

  // Parsing without using a thread
  //Gml gml1 = GmlParsingHelper.getGml(sketchPath+"/17364.gml.xml", false); // Parsing (no normalisation)
  //gmls.add(gml1); // Add it to the gml list

  //Gml gml2 = GmlParsingHelper.getGml(sketchPath+"/17364.gml.xml");
  //gmls.add(gml2); // Add it to the gml list

  // Parsing using a thread (GmlParser)

  // Parsing using folder path (here, using the sketch's root folder)
  //parser.parseFolder(sketchPath, "^.*xml$", false); // Explicitly Parses files with a xml extension (no normalization)
  //parser.parseFolder(sketchPath, "^.*xml$"); // Explicitly parses files with a xml extension
  //parser.parseFolder(sketchPath, false); // Implicitly parses files with a gml extenions (no normalization)
  //parser.parseFolder(sketchPath);

  // Parsing using a list of files previously retrieved
  List<String> files = FileUtils.scanFolder(sketchPath+"/others", "^.*(x|g)ml$"); // Gets a list of files with a xml or gml extension
  //parser.parseFiles(files, false); // Parses the files listed above (no normalization)
  parser.parseFiles(files); // Parses the files listed above

  // Parsing a single file
  //List<String> files = FileUtils.scanFolder(sketchPath+"others", "^.*gml$");  // Gets a list of files with a gml extension
  //parser.parse(files.get(0), false); // Parses the first file found in the list (no normalization)
  //parser.parse(files.get(0));
}

void draw() {
  background(255);
  // Translate to the center of the screen
  translate(width/2, height/2);

  // If we have some Gml in the list
  if (gmls.size() > 0) {
    // Get the currently selected Gml
    Gml gml = gmls.get(current);
    // Set the scaling
    int scaling = height/3;
    // Center the Gml (shift by half width and half height
    translate(-gml.getCentroid().x*scaling, -gml.getCentroid().y*scaling);
    // Draw it
    brushManager.draw(gml, scaling);
  }
  else {
    // Display a loading message
    fill(0);
    text("LOADING ...", 0, 0);
  }
}


// Move the current Gml pointer forward of backward based on the Gml list's size
public void keyPressed() {

  // Forward or backward loop through Gml files stored
  if (gmls.size() > 0) {
    if (key == 'n' || key == 'N') {
      current = ++current%gmls.size();
    }
    else if (key == 'p' || key == 'P') {
      current = current == 0 ? gmls.size()-1 : --current;
    }
  }

  // Various ways to save Gml files
  if (key == '0') { 
    // Save a  single file (no thread used, might slow down your sketch)
    if (null != gmls.get(0)) { // If we have at least one file in the list, save it 
      GmlSavingHelper.save(gmls.get(0), sketchPath+"/backup/test0/gmlfile.gml");  // Use full path including file name
    }
  }

  
  if (key == '1') { 
    // Save a single file using the filename stored in the Gml
    if (null != gmls.get(0)) { // If we have at least one file in the list, save it 
      saver.save(gmls.get(0));
    }
  }


  if (key == '2') { 
    // Save the first Gml of the list using a custom name
    if (null != gmls.get(0)) {
      // Save a single file using the provided name
      saver.save(gmls.get(0), sketchPath("backup")+"/test2/custom_name.gml"); // Use full path including file name
    }
  }

  
  if (key == '3') {
    // Save several Gml files to the same folder using the name stored in the Gmls
    saver.save(gmls, sketchPath+"/backup/test3");
  }

  if (key == '4') {
  // Save several Gml to different locations
    Map<String, Gml> fileLocationMap = prepareSave();
    saver.save(fileLocationMap);
  }
}


//This is just a simple method to store Gml along with their full path (folder+filename)
Map<String, Gml> prepareSave() {

  Map<String, Gml> filesMap = new HashMap<String, Gml>();
  int i=0;
  for (Gml gml : gmls) {
    filesMap.put(sketchPath+"/backup/test4/Backup_"+i+".gml", gml);
    i++;
  }
  return filesMap;
}


// Callback function used by the GmlParser and the GmlSaver to send the result of the parsing and saving events
public void gmlEvent(GmlEvent event) {
  if (event instanceof GmlParsingEvent) { // A parsing event returns a Gml file
    GmlParsingEvent parsingEvent = (GmlParsingEvent) event;
    gmls.add(parsingEvent.gml);
    println("Received a new Gml file : "+parsingEvent.gml.getFileName());
  }
  if (event instanceof GmlSavingEvent) { // A saving event returns only information
    GmlSavingEvent savingEvent = (GmlSavingEvent) event;
    boolean result = savingEvent.successful;
    String location = savingEvent.location;
    println((result ? "Succeeded" : "Failed")+ " saving Gml file to " + location);
  }
}