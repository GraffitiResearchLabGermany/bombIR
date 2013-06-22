package gml4u.brushes;

import gml4u.drawing.GmlStrokeDrawer;
import gml4u.model.GmlPoint;
import gml4u.model.GmlStroke;
import processing.core.PGraphics;
import toxi.geom.Vec3D;

public class CurvesDemo extends GmlStrokeDrawer {

	
	public static final String ID = "GML4U_STYLE_CURVES0000"; 
	
	/**
	 * CurvesDemo constructor
	 */
	public CurvesDemo() {
		super(ID);
		is3D(true);
	}

	/**
	 * Implementation of the abstract method defined in GmlStrokeDrawer
	 */
	public void draw(PGraphics g, GmlStroke stroke, float scale, float minTime, float maxTime) {
			
		g.pushStyle();
		g.strokeWeight(10);
		g.noFill();
		g.beginShape();
		for (GmlPoint point : stroke.getPoints()) {
			if (point.time < minTime) continue;
			if (point.time > maxTime) break;
			
			Vec3D v = point.scale(scale);
			curveVertex(g, v);
		}
		g.endShape();
		g.popStyle();
	}
	
	private static void curveVertex(PGraphics g, Vec3D v) {
		if (g.is3D()) {
			g.curveVertex(v.x, v.y, v.z);
		}
		else {
			g.curveVertex(v.x, v.y);
		}
	}
}
