
//-----------------------------------------------------------------------------------------
// CONFIGURATION - configuration values are stored in data/settings.properties
//add all variables that are set with the settings.properties here
 
//Access to the properties file
P5Properties props;

// debugging mode, log messages are shown on the console
// and the two "windows" appear smaller & on the main screen
boolean debug = false;

// If false, skip camera calibration and use default values (set in settings.properties)
boolean calibrateCamera = true;

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

// BLOB & CALIBRATION variables
float cropScale  = 0.0;
float blobMin    = 0.03;      
float blobMax    = 0.70;
float blobThresh = 0.98;

// TRACKING adjustment variables
float trackingOffsetX = 0.0;
float trackingOffsetY = 0.0;

// SHADER variables (brush)
float brushSize;
float brushSoften;
String brushMap;

// SPRAY variables
int maxStrokes = 10; // How long can the spray ArrayList be?

// 
boolean mirrorX;

boolean alwaysUseMouse;

int ratio;

float captureWidth, captureHeight, captureOffsetY;

//size of the colorpicker
int cpsize;

//index of the paintscreen
int paintscreenIndex;
 

void readConfiguration() {
  try {
    
    props = new P5Properties();
    
    // load a configuration from a file inside the data folder
    props.load(createInput("settings.properties"));
    
    // In debug mode, we print debug messages and the two "windows" 
    // appear smaller in the main screen
    debug           = props.getBooleanProperty ( "env.mode.debug",          false             );
    alwaysUseMouse  = props.getBooleanProperty ( "env.mode.alwaysUseMouse", false             );
    calibrateCamera = props.getBooleanProperty ( "env.mode.calib",          false             );
    cpsize          = props.getIntProperty     ( "env.colorpicker.size",    400               );
    
    // What image file should be used as a background for the paintscreen?
    bgFile          = props.getProperty        ( "env.bg.file",             "background.jpg"  );
    
    // Which camera device are we using?
    camDevice       = props.getProperty        ( "env.camera.device",       "default"         );
    
    // SHADER vars
    brushSize       = props.getIntProperty     ( "env.shader.brushSize",    100               );
    brushSoften     = props.getFloatProperty   ( "env.shader.brushSoften",  0.5               );
    brushMap        = props.getProperty        ( "env.shader.brushMap",     "sprayMap_01.png" );
    
    
    // Proportions of the screen ( 0 = 4:3 and 1 = 16:9 )
    ratio           = props.getIntProperty     ( "env.viewport.ratio",      0                 ); 
    
    
    // Moving the windows around and scaling 
    // depending on debug status and ratio
    
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
    
    
    // Used to keep the aspect ratio of the camera capture image
    // and center it vertically. Also to display the blobs properly.
    
    captureWidth   = firstWindowWidth;
    captureHeight  = firstWindowWidth/4*3; // Keep cropping in 4:3 even in 16:9 mode
    captureOffsetY = - (windowHeight - captureHeight) / 2; // Should equal 0 when in 4:3

    paintscreenIndex = props.getIntProperty    ( "env.viewport.paintscreen.index", 1 );

    // BLOB vars
    blobMin         = props.getFloatProperty   ( "env.mode.blobMin",    0.03  );
    blobMax         = props.getFloatProperty   ( "env.mode.blobMax",    0.70  );
    blobThresh      = props.getFloatProperty   ( "env.mode.blobThresh", 0.98  );
    
    // Flip the x axis of the tracking?
    mirrorX         = props.getBooleanProperty ( "env.mode.mirrorX",    false );
    
    // Adjust tracking position
    trackingOffsetX = props.getFloatProperty   ( "env.mode.trackingOffsetX", 0.0 );
    trackingOffsetY = props.getFloatProperty   ( "env.mode.trackingOffsetY", 0.0 );    

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
