
//-----------------------------------------------------------------------------------------
// CONFIGURATION
 
P5Properties props;
boolean debug = false;
boolean calibrateCamera = false;
int windowHeight;
int windowWidth;
int firstWindowWidth;
 
void readConfiguration() {
  try {
    props = new P5Properties();
    // load a configuration from a file inside the data folder
    props.load(createInput("settings.properties"));
    windowWidth = props.getIntProperty("env.viewport.width", 1024); 
    firstWindowWidth = windowWidth/2;
    windowHeight = props.getIntProperty("env.viewport.height", 384);
    debug = props.getBooleanProperty("env.mode.debug", false);
    calibrateCamera = props.getBooleanProperty("env.mode.calib", false);
    cpsize = props.getIntProperty("env.colorpicker.size",400);
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
