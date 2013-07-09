
//-----------------------------------------------------------------------------------------
// CONFIGURATION - configuration values are stored in data/settings.properties
//add all variables that are set with the settings.properties here
 
//Access to the properties file
P5Properties props;
//debugging mode, logmessage are shown on the console
boolean printDebug = false;
//???
boolean calibrateCamera = false;
//height of the application window
int windowHeight;
//width of the application window
int windowWidth;
//width of the paintscreen
int firstWindowWidth;
//x location of the window
int frameXLocation;
//file for the backgroudn image
String bgFile;
//device of the camera (only set when needed)
String camDevice;
//size of the colorpicker
int cpsize;
 
void readConfiguration() {
  try {
    props = new P5Properties();
    // load a configuration from a file inside the data folder
    props.load(createInput("settings.properties"));
    windowWidth = props.getIntProperty("env.viewport.width", 1024); 
    firstWindowWidth = windowWidth/2;
    windowHeight = props.getIntProperty("env.viewport.height", 384);
    printDebug = props.getBooleanProperty("env.mode.debug", false);
    calibrateCamera = props.getBooleanProperty("env.mode.calib", false);
    cpsize = props.getIntProperty("env.colorpicker.size",400);
    bgFile = props.getProperty("env.bg.file","background.jpg");
    frameXLocation = props.getIntProperty("env.viewport.frame.xlocation",0);
    camDevice = props.getProperty("env.camera.device","default");
  }
  catch(IOException e) {
    println("couldn't read config file...");
  }
}
 
/**
 * simple convenience wrapper object for the standard
 * Properties class to return pre-typed numerals
 */
class P5Properties extends Properties {
 
  boolean getBooleanProperty(String id, boolean defState) {
    return boolean(getProperty(id,""+defState));
  }
 
  int getIntProperty(String id, int defVal) {
    return int(getProperty(id,""+defVal)); 
  }
 
  float getFloatProperty(String id, float defVal) {
    return float(getProperty(id,""+defVal)); 
  }  
}
