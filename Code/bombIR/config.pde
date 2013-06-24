/**
 * configfiles taken from http://wiki.processing.org/index.php/External_configuration_files
 * @author toxi
*/
 
P5Properties props;

//global variables that should be set with the settings.properties file
boolean debug = false;
int windowHeight;
int windowWidth;
 
void readConfiguration() {
  try {
    props=new P5Properties();
    // load a configuration from a file inside the data folder
    props.load(createInput("settings.properties"));
 
    // all values returned by the getProperty() method are Strings
    // so we need to cast them into the appropriate type ourselves
    // this is done for us by the convenience P5Properties class below
    windowWidth = props.getIntProperty("env.viewport.width",1024);
    windowHeight = props.getIntProperty("env.viewport.height",384);
    debug = props.getBooleanProperty("env.mode.debug",false);
 
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
