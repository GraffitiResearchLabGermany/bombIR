class ScreenPreview {
	
	boolean isVisible = false;
	GSCapture screenImage;

	int width;
	int height;

	ScreenPreview( int w, int h ) {
		this.width  = w;
		this.height = h;
	}

	void setScreen(GSCapture scrImg) {
		screenImage = scrImg;
	}

	boolean isVisible() {
           return this.isVisible;
	}

	void show() {
		println("SHOW the preview!");
		if(this.isVisible == false){
			this.isVisible = true;
		}
		else {
			println("ScreenPreview.show() error: screen is already visible");
		}
	}

	void hide() {
		println("HIDE the preview!");
		if(this.isVisible == true){
	             this.isVisible = false;
		}
		else {
			println("ScreenPreview.show() error: screen is already hidden");
		}
	}
        
        // Show the image in a small frame
	void draw() {
		if(null != screenImage) {
			image(screenImage, 0,0, this.width, this.height);
                        pushStyle();
                        noFill();
                        stroke(0,200,150);
                        rect(0,0, this.width, this.height);
                        popStyle();
		}
		else {
			println("ERROR: ScreenPreview.draw() doesn't have an image to display");
		}
	}

}

