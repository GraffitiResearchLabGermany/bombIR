void setupKeystone() {
	ks = new Keystone(this);
  	surface = ks.createCornerPinSurface(340, 256, 20);
    surface.moveTo(341,0);
  	wallscreen = createGraphics(340, 256, P3D);
}
