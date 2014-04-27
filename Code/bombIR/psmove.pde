/**
 * PSMOVE CONTROLLER
 */


/**
 * Define an array of controllers
 */
MoveController [] controllers;
/**
 * TODO: Document this declaration
 */
int rumbleLevel;
/**
 * Color of the sphere of a move controller
 */
color sphereColor;
/**
 * Is a move controller connected?
 */
boolean moveConnected = true;

/**
 * Move buttons
 */

/**
 * Analog trigger button
 */ 
final int TRIGGER_BTN  = 0;
/**
 * TODO: Button with the PS sign on it, right?
 */
final int MOVE_BTN     = 1;
/**
 * Button with the square on it
 */
final int SQUARE_BTN   = 2;
/**
 * Button with the triangle on it
 */
final int TRIANGLE_BTN = 3;
/**
 * Button with the cross on it
 */
final int CROSS_BTN    = 4;
/**
 * Button with the circle on it
 */
final int CIRCLE_BTN   = 5;
/**
 * Button 'start'
 */
final int START_BTN    = 6;
/**
 * Button 'select'
 */
final int SELECT_BTN   = 7;
/**
 * TODO: Which button is that?
 */
final int PS_BTN       = 8;
  

/**
 * Initialize the move
 */
void psmoveInit() {
  int connected = psmoveapi.count_connected();

  // This is only fun if we actually have controllers
  if (connected == 0) {
    logger.warning("No controllers connected.");
    moveConnected = false;
  }
  else if (debug) { 
    String plural = (connected > 1) ? "s":"";
    logger.info("Found "+ connected + " connected controller" + plural);
  }

  controllers = new MoveController[connected];

  // Fill the array with controllers and light them up
  for (int i = 0; i<controllers.length; i++) {
    controllers[i] = new MoveController(i);       
    controllers[i].update(color(255, 0, 0), 0);
  }
} 
// END OF INIT


/** 
 * Update of the move controller(s) 
 *
 * Read out button events, set the sphere color
 */
void psmoveUpdate() {  
  
  for (int i = 0; i<controllers.length; i++) {
    
    rumbleLevel = 0;


    sphereColor = color(
      (int)cs.getColorSlot(activeColorSlot).getRed(), 
      (int)cs.getColorSlot(activeColorSlot).getGreen(), 
      (int)cs.getColorSlot(activeColorSlot).getBlue()
    );
 
    
    // Detect presses on the cap
    if( alwaysUseMouse == false ) {
      clicked = controllers[i].isTriggerPressed();
      clickedEvent = controllers[i].isTriggerPressedEvent();
    }
    
    //if(printDebug) println("clicked = "+clicked);
    
    if ( clicked ) {
      rumbleLevel = rumbleStrength;
    }
    else {
      rumbleLevel = 0;
    }
      
    // Switch through color slots for color selection
    if ( controllers[i].isSquarePressedEvent() ) {
       switchColorSlot();
    }
    
    // Show/hide menub
    if ( controllers[i].isTrianglePressedEvent() ) {
       toggleMenu();
       drawPaintBg();
    }
     
    //sphereColor = color(controllers[i].getTriggerValue());
    
    // Poll controller and update actuators
    controllers[i].update( rumbleLevel, sphereColor );
  }

}


/**
 * Controller class
 *
 * HIC SVNT LEONES!
 *
 * TODO: Document this class
 */
class MoveController extends PSMove {
  

  int triggerValue, previousTriggerValue;
  
  long [] pressed = {0};                         // Button press events
  long [] released = {0};                        // Button release events 
  
  MoveButton[] buttonList = new MoveButton[9];  // The move controller has 9 buttons
  
  boolean isTriggerPressed, isMovePressed, isSquarePressed, isTrianglePressed, isCrossPressed, isCirclePressed, isStartPressed, isSelectPressed, isPsPressed; 

    /**
   * Constructor
   *
   * @param i id of the controller (?)
   */
  MoveController(int i) {
    super(i);
    init();
  }
  
  /**
   * Initialize controller
   */
  void init() {
    createButtons();
    movePoll();
  }
  
  /**
   * Populate the moveButton[] array of the controller with MoveButton objects.
   */
  void createButtons() {
    for (int i=0; i<buttonList.length; i++) {
      buttonList[i] = new MoveButton();
    }
  }

  
  
   /** 
   * Get the value of the Trigger button
   *
   * TODO: What's the range here?
   *
   * @return the value of the trigger press 
   */
  public int getTriggerValue() {
    return buttonList[TRIGGER_BTN].getValue();
  }

  /**
   * Ís the Trigger Button pressed?
   *
   * @return true if Trigger is pressed, false otherwise
   */
  public boolean isTriggerPressed() {
    return buttonList[TRIGGER_BTN].isPressed();
  }

  /**
   * Ís the Move Button pressed?
   *
   * @return true if Move Button is pressed, false otherwise
   */
  public boolean isMovePressed() {
    return buttonList[MOVE_BTN].isPressed();
  }
  
  /**
   * Ís the Square Button pressed?
   *
   * @return true if Square Button is pressed, false otherwise
   */
  public boolean isSquarePressed() {
    return buttonList[SQUARE_BTN].isPressed();
  }

 /**
   * Ís the Triangle Button pressed?
   *
   * @return true if Triangle Button is pressed, false otherwise
   */
  public boolean isTrianglePressed() {
    return buttonList[TRIANGLE_BTN].isPressed();
  }

  /**
   * Ís the Cross Button pressed?
   *
   * @return true if Cross Button is pressed, false otherwise
   */
  public boolean isCrossPressed() {
    return buttonList[CROSS_BTN].isPressed();
  }

  /**
   * Ís the Circle Button pressed?
   *
   * @return true if Circle Button is pressed, false otherwise
   */
  public boolean isCirclePressed() {
    return buttonList[CIRCLE_BTN].isPressed();
  }

  /**
   * Ís the Select Button pressed?
   *
   * @return true if Select Button is pressed, false otherwise
   */
  public boolean isSelectPressed() {
    return buttonList[SELECT_BTN].isPressed();
  }

  /**
   * Ís the Start Button pressed?
   *
   * @return true if Start Button is pressed, false otherwise
   */
  public boolean isStartPressed() {
    return buttonList[START_BTN].isPressed();
  }

   /**
   * Ís the PS Button pressed?
   *
   * @return true if PS Button is pressed, false otherwise
   */
  public boolean isPsPressed() {
    return buttonList[PS_BTN].isPressed();
  }    

  /**
   * Button events 
   *
   * Tells if a given button was pressed/released
   * since the last call to the event function
   *
   */

  /**
   * Was the Trigger button pressed since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isTriggerPressedEvent() {
    boolean event = buttonList[TRIGGER_BTN].isPressedEvent();
    return event;
  }

 /**
   * Was the Move button pressed since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isMovePressedEvent() {
    boolean event = buttonList[MOVE_BTN].isPressedEvent();
    return event;
  }
  
  /**
   * Was the Square button pressed since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isSquarePressedEvent() {
    boolean event = buttonList[SQUARE_BTN].isPressedEvent();
    return event;
  }

  /**
   * Was the Triangle button pressed since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isTrianglePressedEvent() {
    boolean event = buttonList[TRIANGLE_BTN].isPressedEvent();
    return event;
  }

  /**
   * Was the Cross button pressed since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isCrossPressedEvent() {
    boolean event = buttonList[CROSS_BTN].isPressedEvent();
    return event;
  }

 /**
   * Was the Circle button pressed since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isCirclePressedEvent() {
    boolean event = buttonList[CIRCLE_BTN].isPressedEvent();
    return event;
  }

  /**
   * Was the Select button pressed since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isSelectPressedEvent() {
    boolean event = buttonList[SELECT_BTN].isPressedEvent();
    return event;
  }

  /**
   * Was the Start button pressed since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isStartPressedEvent() {
    boolean event = buttonList[START_BTN].isPressedEvent();
    return event;
  }
  
  /**
   * Was the PS button pressed since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isPsPressedEvent() {
    boolean event = buttonList[PS_BTN].isPressedEvent();
    return event;
  }    

  /**
   * Was the Trigger button released since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isTriggerReleasedEvent() {
    boolean event = buttonList[TRIGGER_BTN].isReleasedEvent();
    return event;
  }

  /**
   * Was the Move button released since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isMoveReleasedEvent() {
    boolean event = buttonList[MOVE_BTN].isReleasedEvent();
    return event;
  }

  /**
   * Was the Square button released since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isSquareReleasedEvent() {
    boolean event = buttonList[SQUARE_BTN].isReleasedEvent();
    return event;
  }

  /**
   * Was the Triangle button released since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isTriangleReleasedEvent() {
    boolean event = buttonList[TRIANGLE_BTN].isReleasedEvent();
    return event;
  }

 /**
   * Was the Cross button released since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isCrossReleasedEvent() {
    boolean event = buttonList[CROSS_BTN].isReleasedEvent();
    return event;
  }

  /**
   * Was the Circle button released since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isCircleReleasedEvent() {
    boolean event = buttonList[CIRCLE_BTN].isReleasedEvent();
    return event;
  }

  /**
   * Was the Select button released since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isSelectReleasedEvent() {
    boolean event = buttonList[SELECT_BTN].isReleasedEvent();
    return event;
  }

  /**
   * Was the Start button released since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isStartReleasedEvent() {
    boolean event = buttonList[START_BTN].isReleasedEvent();
    return event;
  }

  /**
   * Was the PS button released since the last call of the event function?
   * 
   * @return true if yes, false otherwise
   */
  public boolean isPsReleasedEvent() {
    boolean event = buttonList[PS_BTN].isReleasedEvent();
    return event;
  }
  

  
  /**
   * Update
   *
   * TODO: which range can be used for rumble level?
   * 
   * @param _rumbleLevel the amount the move should rumble
   * @param _sphereColor the color the move should show
   */
  void update(int _rumbleLevel, color _sphereColor) {
    
    movePoll();
    
    int r, g, b;
    
    r = (int)red(_sphereColor);
    g = (int)green(_sphereColor);
    b = (int)blue(_sphereColor);
    
    super.set_leds(r, g, b);
    
    super.set_rumble(_rumbleLevel);
    
    super.update_leds(); // actually, it also updates the rumble... don't ask
    
  } // END OF UPDATE
  
  
  
  /**
   * updatePoll 
   * Read inputs from the Move controller (buttons and sensors)
   */
  private void movePoll() { 
      
    // Update all readings in the PSMove object
          
    while ( super.poll() != 0 ) {} 
    
    // Start by reading all the buttons from the controller
    
    int buttons = super.get_buttons();      
        
    // Then update individual MoveButton objects in the buttonList array
    
    
    if ((buttons & io.thp.psmove.Button.Btn_MOVE.swigValue()) != 0) {
      buttonList[MOVE_BTN].press();
    }
    // ERROR: this causes nullPointerException
    else if (buttonList[MOVE_BTN].isPressed()) {
      buttonList[MOVE_BTN].release();
    }
    
    if ((buttons & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
      buttonList[SQUARE_BTN].press();
    } 
    else if (buttonList[SQUARE_BTN].isPressed()) {
      buttonList[SQUARE_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_TRIANGLE.swigValue()) != 0) {
      buttonList[TRIANGLE_BTN].press();
    } 
    else if (buttonList[TRIANGLE_BTN].isPressed()) {
      buttonList[TRIANGLE_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_CROSS.swigValue()) != 0) {
      buttonList[CROSS_BTN].press();
    } 
    else if (buttonList[CROSS_BTN].isPressed()) {
      buttonList[CROSS_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_CIRCLE.swigValue()) != 0) {
      buttonList[CIRCLE_BTN].press();
    } 
    else if (buttonList[CIRCLE_BTN].isPressed()) {
      buttonList[CIRCLE_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_START.swigValue()) != 0) {
      buttonList[START_BTN].press();
    } 
    else if (buttonList[START_BTN].isPressed()) {
      buttonList[START_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_SELECT.swigValue()) != 0) {
      buttonList[SELECT_BTN].press();
    } 
    else if (buttonList[SELECT_BTN].isPressed()) {
      buttonList[SELECT_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_PS.swigValue()) != 0) {
      buttonList[PS_BTN].press();
    } 
    else if (buttonList[PS_BTN].isPressed()) {
      buttonList[PS_BTN].release();
    }

    // Now the same for the events
    
    // Start by reading all events from the controller
    
    super.get_button_events(pressed, released);
    // Then register the current individual events to the corresponding MoveButton objects in the buttonList array
    if ((pressed[0] & io.thp.psmove.Button.Btn_MOVE.swigValue()) != 0) {
      logger.fine("The Move button was just pressed.");
      buttonList[MOVE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_MOVE.swigValue()) != 0) {
      logger.fine("The Move button was just released.");
      buttonList[MOVE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
      logger.fine("The Square button was just pressed.");
      buttonList[SQUARE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
      logger.fine("The Square button was just released.");
      buttonList[SQUARE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_TRIANGLE.swigValue()) != 0) {
      logger.fine("The Triangle button was just pressed.");
      buttonList[TRIANGLE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_TRIANGLE.swigValue()) != 0) {
      logger.fine("The Triangle button was just released.");
      buttonList[TRIANGLE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_CROSS.swigValue()) != 0) {
      logger.fine("The Cross button was just pressed.");
      buttonList[CROSS_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_CROSS.swigValue()) != 0) {
      logger.fine("The Cross button was just released.");
      buttonList[CROSS_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_CIRCLE.swigValue()) != 0) {
      logger.fine("The Circle button was just pressed.");
      buttonList[CIRCLE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_CIRCLE.swigValue()) != 0) {
      logger.fine("The Circle button was just released.");
      buttonList[CIRCLE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_START.swigValue()) != 0) {
      logger.fine("The Start button was just pressed.");
      buttonList[START_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_START.swigValue()) != 0) {
      logger.fine("The Start button was just released.");
      buttonList[START_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_SELECT.swigValue()) != 0) {
      logger.fine("The Select button was just pressed.");
      buttonList[SELECT_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_SELECT.swigValue()) != 0) {
      logger.fine("The Select button was just released.");
      buttonList[SELECT_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_PS.swigValue()) != 0) {
      logger.fine("The PS button was just pressed.");
      buttonList[PS_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_PS.swigValue()) != 0) {
      logger.fine("The PS button was just released.");
      buttonList[PS_BTN].eventRelease();
    }

    
    // Read the trigger information from the controller
    
    previousTriggerValue = triggerValue;             // Store the previous value
    triggerValue = super.get_trigger();              // Get the new value
    buttonList[TRIGGER_BTN].setValue(triggerValue); // Send the value to the button object

    
    // press/release behaviour for the trigger
    
    if (triggerValue>0) {
      buttonList[TRIGGER_BTN].press();
      if (previousTriggerValue == 0) { // Catch trigger presses
        logger.fine("The Trigger button was just pressed.");
        buttonList[TRIGGER_BTN].eventPress();
      }
    }
    else if (previousTriggerValue>0) { // Catch trigger releases
      logger.fine("The Trigger button was just released.");
      buttonList[TRIGGER_BTN].eventRelease();
      buttonList[TRIGGER_BTN].release();
    }
    else buttonList[TRIGGER_BTN].release();
    
  }
  // END OF UPDATE POLL
  
  /**
   * Shutdown move
   */
  void shutdown() {
      super.set_rumble(0);
      super.set_leds(0, 0, 0);
      super.update_leds();
  }
  

}

// END OF MOVE CONTROLLER



/**
 * Button class 
 */
class MoveButton {
  
  protected boolean isPressed;
  //boolean isPressedEvent, isReleasedEvent;
  protected int value; // For analog buttons only (triggers)
  protected int previousValue; // For analog buttons only (triggers)
  
  
  // We store multiple catchers for the event in case we need to make 
  // several queries; the event catcher is set to false after the query 
  // so we can only use each event catcher once. To do so, we can use 
  // isPressedEvent(i) where i is the id of the catcher.
  protected boolean[] pressedEvents;
  protected boolean[] releasedEvents;

  /**
   * Constructor
   */
  public MoveButton() {
    isPressed = false;
    pressedEvents = new boolean[64];
    releasedEvents = new boolean[64];
    value = 0;
  }
  
  /**
   * Press button 
   */
  public void press() {
    isPressed = true;
  }

  /**
   * Release button 
   */
  public void release() { 
    isPressed = false;
  }
  
  /**
   * TODO: Document this method
   */
  public void eventPress() {
    for(int i=0; i < pressedEvents.length; i++) {
      pressedEvents[i] = true; // update all the event catchers
    }
  }
  
  /**
   * TODO: Document this method
   */
  public void eventRelease() {
    for(int i=0; i < releasedEvents.length; i++) {
      releasedEvents[i] = true; // update all the event catchers
    }
  }
  
  /**
   * Returns true if there is a pressedEvent for this button
   * 
   * @return true if pressedEvent, false otherwise
   */
  public boolean isPressedEvent() {
    if(pressedEvents[0]) {
      pressedEvents[0] = false; // Reset the main event catcher
      return true;
    }
    return false;
  }
  
  /**
   * Returns true if there is a releasedEvent for this button
   * 
   * @return true if releasedEvent, false otherwise
   */
  public boolean isReleasedEvent() {
    if(releasedEvents[0]) {
      releasedEvents[0] = false; // Reset the main event catcher
      return true;
    }
    return false;
  }
  
  /**
   * TODO: Document this method
   */
  public boolean isPressedEvent(int i) {
    if(pressedEvents[i]) {
      pressedEvents[i] = false; // Reset the selected event catcher
      return true;
    }
    return false;
  }
  
  /**
   * TODO: Document this method
   */
  public boolean isReleasedEvent(int i) {
    if(releasedEvents[i]) {
      releasedEvents[i] = false; // Reset the selected event catcher
      return true;
    }
    return false;
  }
  
  /**
   * Is the button pressed?
   *
   * @return true if pressed, false otherwise
   */
  public boolean isPressed() {
    return isPressed;
  }

  /**
   * TODO: Document this method
   */
  public void setValue(int _val) { 
    previousValue = value;
    value = _val;
  }
  
  /**
   * TODO: Document this method
   */
  public int getValue() {    
    return value;
  }
}
