/**
 * Displays a thumbnail preview of the camera
 */
class ScreenPreview {
	
	boolean isVisible = false;
	GSCapture screenImage;

	int width;
	int height;
        
        // Values to show cropping
        float height_16_9;
        float offsetY_16_9;

  /**
   * Constructor
   *
   * @param w width of the screen
   * @param h height of the screen
   */
  public ScreenPreview( int w, int h ) {
    this.width   = w;
	this.height  = h;
    height_16_9  = this.height * 0.75;
    offsetY_16_9 = ( this.height - height_16_9 ) / 2;
  }

  /**
   * TODO: Document this method
   * 
   * @param scrImg
   */
  public void setScreen(GSCapture scrImg) {
    screenImage = scrImg;
  }

  /**
   * Is the screen visible?
   *
   * @return true if yes, false otherwise
   */
  public boolean isVisible() {
    return this.isVisible;
  }
  
  /**
   * Show the screen
   */
  public void show() {
	if(this.isVisible == false){
	  this.isVisible = true;
	} else {
	  logger.warning("screen is already visible");
	}
  }

  /**
   * Hide the screen
   */
  public void hide() {
	if(this.isVisible == true){
	  this.isVisible = false;
	} else {
	  logger.warning("screen is already hidden");
	}
  }
        
  /**
   * Show the image in a small frame
   */
  public void draw() {
	if(null != screenImage) {
	  image(screenImage, 0,0, this.width, this.height);
            pushStyle();
            noFill();
            stroke(10,200,50);
            rect( 0, 0,            this.width, this.height ); // frame 4:3
            rect( 0, offsetY_16_9, this.width, height_16_9 ); // frame 16:9
            popStyle();
	} else {
	  logger.severe("doesn't have an image to display");
	}
  }
}

