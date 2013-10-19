/**
 * Mouse Robot
 *
 * Controls the mouse when IR tracking is used
 */

/**
 * Moves the mouse when according to the blob
 */
Robot mouseRobot;


/**
 * Setup the mouse robot
 */
void setupMouseRobot(){
	try {
		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        GraphicsDevice[] gs = ge.getScreenDevices();
        if (paintscreenIndex >= gs.length){
        	logger.warning("No screen with index " + paintscreenIndex + " available. Falling back to primary screen");
        	paintscreenIndex = 0;
        } 
    	mouseRobot = new Robot(gs[paintscreenIndex]);
           	
  	} catch (AWTException e) {
    	logger.severe("Robot class not supported by your system!");
 		exit();
  	}
}

/**
 * Let the robot control the mouse according to the blob tracking
 */
void controlMouse(){
	//let the blob control the mouse when the menu is visible and 
	//the move is connected
	if(moveConnected  && alwaysUseMouse == false) {
  
        int xRobot = int ( firstWindowWidth - ( blobX - frameXLocation ) - frameXLocation * 2 ); // CRAZY! Fix this later
        int yRobot = int ( blobY );
                
		mouseRobot.mouseMove( xRobot, yRobot );

        logger.fine("xRobot = " +xRobot+" | yRobot = "+ yRobot + " | firstWindowWidth = " + firstWindowWidth );               
	}

	if(clicked){
		mouseRobot.mousePress(InputEvent.BUTTON1_MASK);
	}
	if(!clicked) {
		mouseRobot.mouseRelease(InputEvent.BUTTON1_MASK);
	}
}