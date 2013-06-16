void setupKeystone() {
	ks = new Keystone(this);
  	surface = ks.createCornerPinSurface(windowWidth/2, windowHeight, 20);
        surface.moveTo(windowWidth/2+1,0);
  	wallscreen = createGraphics(windowWidth/2, windowHeight, P3D);
}
