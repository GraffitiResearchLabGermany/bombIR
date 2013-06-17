class CustomDrawer extends GmlStrokeDrawer {

 public static final String ID = "My Custom Brush";
  
  public CustomDrawer() {
    super(ID);
    is3D(true);
  }

  /**
  * Implementation of the abstract method defined in GmlStrokeDrawer
  */
   void draw(PGraphics g, GmlStroke stroke, float scale, float minTime, float maxTime) {
    
    g.pushStyle();
    g.fill(255);
    g.stroke(0);
    float rot = 0;
    for (GmlPoint point : stroke.getPoints()) {
      if (point.time < minTime) continue;
      if (point.time > maxTime) break;

      Vec3D v = point.scale(scale);
      g.pushMatrix();
      if (g.is3D()) {
        g.translate(v.x, v.y, v.z);
        g.rotate(rot+=.01);
        g.fill(random(255));
        g.box(10);
      }
      else {
        g.translate(v.x, v.y);
        g.rotate(rot+=.01);
        g.fill(random(255));
        g.rect(-10, -10, 10, 10);
      }
      g.popMatrix();
    }
    g.popStyle();
  }


}

