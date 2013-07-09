//moves the mouse when according to the blob
Robot mouseRobot;

//setup the mouse robot
void setupMouseRobot(){
	try {
    	mouseRobot = new Robot();
  	} catch (AWTException e) {
    	println("Robot class not supported by your system!");
    	exit();
  	}
}


void controlMouse(){
	//let the blob control the mouse when the menu is visible and 
	//the move is connected
	if(moveConnected && menu.isVisible()) {
		mouseRobot.mouseMove((int)blobX, (int)blobY);
	}

	if(clicked){
		mouseRobot.mousePress(InputEvent.BUTTON1_MASK);
	}
	if(!clicked) {
		mouseRobot.mouseRelease(InputEvent.BUTTON1_MASK);
	}
}

