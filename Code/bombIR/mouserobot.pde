//moves the mouse when according to the blob
Robot mouseRobot;


//setup the mouse robot
void setupMouseRobot(){
	try {

		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        GraphicsDevice[] gs = ge.getScreenDevices();
        if (paintscreenIndex >= gs.length){
        	println("No screen with index " + paintscreenIndex + " available. Falling back to primary screen");
        	paintscreenIndex = 0;
        } 
    	mouseRobot = new Robot(gs[paintscreenIndex]);
           	
  	} catch (AWTException e) {
    	println("Robot class not supported by your system!");
 		exit();
  	}
}


void controlMouse(){
	//let the blob control the mouse when the menu is visible and 
	//the move is connected
	if(moveConnected && menu.isVisible() && alwaysUseMouse == false) {
		mouseRobot.mouseMove((int)blobX+frameXLocation, (int)blobY);
	}

	if(clicked){
		mouseRobot.mousePress(InputEvent.BUTTON1_MASK);
	}
	if(!clicked) {
		mouseRobot.mouseRelease(InputEvent.BUTTON1_MASK);
	}
}

