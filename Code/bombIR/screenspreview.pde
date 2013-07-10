class ScreenPreview {
	
	boolean isVisible = false;
	PGraphics screenImage;

	int width;
	int height;

	ScreenPreview( int w, int h ) {
		this.width  = w;
		this.height = h;
	}

	void setScreen(PGraphics scrImg) {
		screenImage = scrImg;
	}

	boolean isVisible() {
		return isVisible;
	}

	void show() {
		if(!this.isVisible){
			isVisible = true;
		}
		else {
			println("ScreenPreview.show() error: screen is already visible");
		}
	}

	void hide() {
		if(this.isVisible){
			isVisible = false;
		}
		else {
			println("ScreenPreview.show() error: screen is already hidden");
		}
	}

	void draw() {
		if(null != screenImage) {
			image(screenImage, 0,0, this.width, this.height);
		}
		else {
			println("ERROR: ScreenPreview.draw() doesn't have an image to display");
		}
	}

}

