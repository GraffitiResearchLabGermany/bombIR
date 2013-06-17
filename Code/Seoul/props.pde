
//-----------------------------------------------------------------------------------------

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

//-----------------------------------------------------------------------------------------
