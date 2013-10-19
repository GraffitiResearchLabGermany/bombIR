/**
 * MOUSE CONTROL
 */

/**
 * Create a clickEvent when left mouse button is pressed
 */
void mousePressed() {
  if( moveConnected == false || alwaysUseMouse == true ) {
  	clickedEvent = true;
  } 
}

/**
 * Set clicked to true when mouse is dragged with mouse button pressed
 */
void mouseDragged() {
  if( moveConnected == false || alwaysUseMouse == true ) {
    clicked = true;
  }
}

/**
 * Set clicked to false when mouse button is released
 */
void mouseReleased() {
  if( moveConnected == false || alwaysUseMouse == true ) {
    clicked = false;
  }
}