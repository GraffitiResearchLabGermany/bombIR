
//-----------------------------------------------------------------------------------------
// MOUSE CONTROL

void mousePressed() {
  
 if( moveConnected == false || alwaysUseMouse == true )  clickedEvent = true; 
 
}

void mouseDragged() {

 if( moveConnected == false || alwaysUseMouse == true ) {
   clicked = true;
 }

}

void mouseReleased() {
 
 if( moveConnected == false || alwaysUseMouse == true ) {
   clicked = false;
 }
 
}
