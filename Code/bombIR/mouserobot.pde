
MouseRobotThread mt;

void setupMouseRobot(){
	mt = new MouseRobotThread("MouseRobot", this, paintscreenIndex, firstWindowWidth, frameXLocation);
	mt.start();
}

//Thread for controlling the Mouse when the blob moves
//and buttons are pressed
class MouseRobotThread extends Thread{
	GraphicsEnvironment ge;
	GraphicsDevice[] gs;
	int screenIndex;
	boolean running;
	String id;
	PApplet applet;
	//moves the mouse when according to the blob
	Robot mouseRobot;
	int firstWindowWidth;
	int frameXLocation;
	int xRobot;
	int yRobot;


	public MouseRobotThread(String id, PApplet applet, int screenIndex, int firstWindowWidth, int frameXLocation){
		this.id = id;
		this.applet = applet;
		this.screenIndex = screenIndex; 
		this.firstWindowWidth = firstWindowWidth;
		this.frameXLocation = frameXLocation;
	}

	public void start(){
    	running = true;
    	println("Starting MouseRobot Thread...");

    	try {

			this.ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
	        this.gs = this.ge.getScreenDevices();
	        if (this.screenIndex >= this.gs.length){
	        	println("No screen with index " + this.screenIndex + " available. Falling back to primary screen");
	        	this.screenIndex = 0;
	        } 
	    	this.mouseRobot = new Robot(this.gs[this.screenIndex]);
	           	
	  	} catch (AWTException e) {
	    	println("Robot class not supported by your system!");
	 		this.quit();
	  	}
	}

	public void run(){
    	//nothing to be done here
  	}

	public void updateMouse(float blobX, float blobY, boolean clicked){
		//let the blob control the mouse when the menu is visible and 
		//the move is connected
	    this.xRobot = int ( this.firstWindowWidth - ( blobX - this.frameXLocation ) - this.frameXLocation * 2 ); // CRAZY! Fix this later
	    this.yRobot = int ( blobY );
	                
		mouseRobot.mouseMove( this.xRobot, this.yRobot );

	    //println("xRobot = " +xRobot+" | yRobot = "+ yRobot + " | firstWindowWidth = " + firstWindowWidth );
	                
		if(clicked){
			this.mouseRobot.mousePress(InputEvent.BUTTON1_MASK);
		}
		if(!clicked) {
			this.mouseRobot.mouseRelease(InputEvent.BUTTON1_MASK);
		}
	}

	/**
   	 * Stop camera and blob detection
   	 */
  	public void quit(){
	    println("Quitting MouseRobot Thread...");
	    this.running = false;
	    this.mouseRobot = null;
	    interrupt();
 	}
}

