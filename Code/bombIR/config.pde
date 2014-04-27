/**
 * CONFIGURATION 
 * 
 * Configuration values are stored in data/settings.properties
 * add all variables that are set with the settings.properties here
 */

/**
 * Access to the properties file
 */
P5Properties props;
/**
 * Debugging mode, log messages are shown on the console
 * and the two "windows" appear smaller & on the main screen
 */
boolean debug = false;
/** 
 * If false, skip camera calibration and use default values (set in settings.properties)
 */
boolean calibrateCamera = true;
/**
 * Height of the application window
 */
int windowHeight;
/**
 * Width of the application window
 */
int windowWidth;
/**
 * Width of the paintscreen
 */
int firstWindowWidth;
/**
 * x location of the window
 */
int frameXLocation;
/**
 * File for the backgroudn image
 */
String bgFile;
/**
 * Device of the camera (only set when needed)
 */
String camDevice;

/** 
 * BLOB & CALIBRATION variables
 */

/**
 * TODO: Document this declaration
 */
float cropScale  = 0.0;
/**
 * TODO: Document this declaration
 */
float blobMin    = 0.03;
/**
 * TODO: Document this declaration
 */      
float blobMax    = 0.70;
/**
 * TODO: Document this declaration
 */
float blobThresh = 0.98;

/**
 * TRACKING adjustment variables
 */

 /**
 * TODO: Document this declaration
 */
float trackingOffsetX = 0.0;
/**
 * TODO: Document this declaration
 */
float trackingOffsetY = 0.0;

/**
 * CONTROLLER variables
 */
 /**
 * TODO: Document this declaration
 */
int rumbleStrength;

/**
 * SHADER variables (brush)
 */
/**
 * TODO: Document this declaration
 */
float brushSize;
/**
 * TODO: Document this declaration
 */
float brushSoften;
/**
 * TODO: Document this declaration
 */
String brushMap;

/**
 * SPRAY variables
 */

/**
 * How long can the spray ArrayList be?
 */
int maxStrokes = 10;
/**
 * Display an indicator of the brush size
 */
boolean showSize = true; // 

/**
 * TODO: Document this declaration
 */
boolean mirrorX;
/**
 * TODO: Document this declaration
 */
boolean alwaysUseMouse;
/**
 * TODO: Document this declaration
 */
int ratio;
/**
 * TODO: Document this declaration
 */
float captureWidth;
/**
 * TODO: Document this declaration
 */
float captureHeight;
/**
 * TODO: Document this declaration
 */
float captureOffsetY;
/**
 * Size of the colorpicker
 */
int cpsize;
/**
 * Index number of the paintscreen in a multi monitor setup 
 */
int paintscreenIndex;
/**
 * Read the configuration values from the 'settings.properties' file in the data folder
 * and set the variable values accordingly
 */
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
    
    // How much should the controller vibrate when pressed?
    rumbleStrength  = props.getIntProperty     ( "env.controller.rumble",   120               );
    
    // SHADER vars
    brushSize       = props.getIntProperty     ( "env.shader.brushSize",    100               );
    brushMap        = props.getProperty        ( "env.shader.brushMap",     "sprayMap_01.png" );
    brushSoften     = props.getFloatProperty   ( "env.shader.brushSoften",  0.5               );    
    
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
    
    // Display an indicator of the brush size
    showSize         = props.getBooleanProperty ( "env.mode.showSize",  true  );

    
    // Flip the x axis of the tracking?
    mirrorX         = props.getBooleanProperty ( "env.mode.mirrorX",    false );
    
    // Adjust tracking position
    trackingOffsetX = props.getFloatProperty   ( "env.mode.trackingOffsetX", 0.0 );
    trackingOffsetY = props.getFloatProperty   ( "env.mode.trackingOffsetY", 0.0 );    

  }
  catch(IOException e) {
    logger.warning("couldn't read config file...");
  }
}
 
/**
 * Simple convenience wrapper object for the standard
 * Properties class to return pre-typed numerals
 */
class P5Properties extends Properties {
  
  /**
   * @param id the id of the property to get the value from
   * @param defState default value of the property if no value is found in config file
   * @return the boolean value of the property
   */
  public boolean getBooleanProperty(String id, boolean defState) {
    return boolean(getProperty(id,""+defState));
  }
  
  /**
   * @param id the id of the property to get the value from
   * @param defState default value of the property if no value is found in config file
   * @return the int value of the property
   */
  public int getIntProperty(String id, int defVal) {
    return int(getProperty(id,""+defVal));
  }
 
  /**
   * @param id the id of the property to get the value from
   * @param defState default value of the property if no value is found in config file
   * @return the float value of the property
   */
  public float getFloatProperty(String id, float defVal) {
    return float(getProperty(id,""+defVal)); 
  }   
}
