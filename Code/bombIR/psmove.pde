PSMove move;
PSMove [] controllers; // Define an array of controllers
long lastTime = 0;

// Setup of the move -------------------------------------------------------------

void psmoveInit() {
  int connected = psmoveapi.count_connected();
  
  lastTime = millis();

  // This is only fun if we actually have controllers
  if (connected == 0) {
    print("WARNING: No controllers connected.");
  }

  controllers = new PSMove[connected];

  // Fill the array with controllers and light them up in white
  for (int i = 0; i<controllers.length; i++) {
    controllers[i] = new PSMove(i);
    controllers[i].set_leds(255, 0, 255);
    controllers[i].update_leds();
  }
} 
// END OF INIT


// Update of the move controller ---------------------------------------------------------

void psmoveUpdate() {
  for (int i = 0; i<controllers.length; i++) {
      controllers[i].set_leds(
      (int)colorSlots[activeColorSlot].getRed(), 
      (int)colorSlots[activeColorSlot].getGreen(), 
      (int)colorSlots[activeColorSlot].getBlue()
    );
    controllers[i].update_leds();
    while (controllers[i].poll () != 0) {
      int trigger = controllers[i].get_trigger();
      int buttons = controllers[i].get_buttons();
      if ( trigger > 0){ 
        clicked = true;
      } else {
        clicked = false;  
      } 
      //switch through color slots for color selection
      if ((buttons & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
        //wait half a second before switching to the next color to 
        //avoid skipping colors when holding the button for too long  
        if ( millis() - lastTime > 500 ) {
           switchColorSlot();
           lastTime = millis();
         }
      } 
    }
  }
}



