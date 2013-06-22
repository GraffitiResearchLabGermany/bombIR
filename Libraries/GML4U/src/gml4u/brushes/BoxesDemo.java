package gml4u.brushes;

import gml4u.drawing.GmlStrokeDrawer;
import gml4u.model.GmlPoint;
import gml4u.model.GmlStroke;
import processing.core.PApplet;
import processing.core.PGraphics;

public class BoxesDemo extends GmlStrokeDrawer {
	

	public static final String ID = "GML4U_STYLE_BOXES0000"; 

	/**
	 * BoxesDemo constructor
	 */
	public BoxesDemo() {
		super(ID);
		is3D(true);
	}

	/**
	 * Implementation of the abstract method defined in GmlStrokeDrawer
	 */
	public void draw(PGraphics g, GmlStroke stroke, float scale, float minTime, float maxTime) {
			
		GmlPoint prev = new GmlPoint();
		GmlPoint cur = new GmlPoint();
						
		for (GmlPoint point: stroke.getPoints()) {
			if (point.time < minTime) continue;
			if (point.time > maxTime) break;
			
			if (prev.isZeroVector()) {
				prev.set(point.scale(scale));
			}
			cur.set(point.scale(scale));
			g.pushMatrix();
			if (g.is3D()) {
				g.translate(cur.x, cur.y, cur.z);
				g.rotate(cur.distanceTo(prev));
				g.box(cur.distanceTo(prev));
			}
			else {
				g.translate(cur.x, cur.y);
				g.rotate(cur.distanceTo(prev));
				g.rectMode(PApplet.CENTER);
				g.rect(0, 0, cur.distanceTo(prev), cur.distanceTo(prev));
			}
			g.popMatrix();
			prev.set(cur);
		}
	}
}