PImage bg;

  void setupKeystone() {
	ks = new Keystone(this);
        
        surface = ks.createCornerPinSurface(windowWidth/2, windowHeight, 20);
        surface.moveTo(windowWidth/2+1,0);
  	wallscreen = createGraphics(windowWidth/2, windowHeight, P3D);
        wallscreen.background(0);  
        
        paintbg = ks.createCornerPinSurface(windowWidth/2, windowHeight, 20);
        paintbg.moveTo(0,0);
        paintbackground = createGraphics(windowWidth/2,windowHeight,P3D);
        bg = loadImage("background.jpg");
        bg.resize(windowWidth/2, windowHeight);
        paintbackground.beginDraw();
        paintbackground.image(bg,0,0);
        paintbackground.endDraw();      
  }
