
//-----------------------------------------------------------------------------------------
// CONFIGURATION
 
P5Properties props;
boolean debug = false;
boolean calibrateCamera = false;
boolean alwaysUseMouse = false;
int windowHeight;
int windowWidth;
int firstWindowWidth;
int frameXLocation;
String bgFile;
String camDevice;

float brushSize;
float brushSoften;
String brushMap;

int ratio;

void readConfiguration() {
  try {
    props = new P5Properties();
    // load a configuration from a file inside the data folder
    props.load(createInput("settings.properties"));
    debug = props.getBooleanProperty("env.mode.debug", false);
    alwaysUseMouse = props.getBooleanProperty("env.mode.alwaysUseMouse", false);
    calibrateCamera = props.getBooleanProperty("env.mode.calib", false);
    cpsize = props.getIntProperty("env.colorpicker.size",400);
    bgFile = props.getProperty("env.bg.file","background.jpg");
    camDevice = props.getProperty("env.camera.device","default");
    brushSize = props.getIntProperty("env.shader.brushSize",100);
    brushSoften = props.getFloatProperty("env.shader.brushSoften",0.5);
    brushMap = props.getProperty("env.shader.brushMap","sprayMap_01.png");
    
    ratio = props.getIntProperty( "env.viewport.ratio", 0 ); // 0 = 4:3 and 1 = 16:9
    
    if(debug) { // if we're using the main screen (debug mode)
      frameXLocation = props.getIntProperty("env.viewport.frame.xlocation_debug",0);
      if(ratio == 0) { // 4:3
        windowWidth = props.getIntProperty("env.viewport.width_4_3", 1600); 
        windowHeight = props.getIntProperty("env.viewport.height_4_3", 600);
      }
      else if(ratio == 1) { // 16:9
        windowWidth = props.getIntProperty("env.viewport.width_16_9", 1600); 
        windowHeight = props.getIntProperty("env.viewport.height_16_9", 450);
      }
      frameXLocation = props.getIntProperty("env.viewport.frame.xlocation_debug",0);
    }
    else { // if we're using the secondary screens (performance mode)
      windowWidth    = props.getIntProperty("env.viewport.width", 1024); 
      windowHeight   = props.getIntProperty("env.viewport.height", 384);
      frameXLocation = props.getIntProperty("env.viewport.frame.xlocation",0);
    }
    
    firstWindowWidth = windowWidth/2;

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
