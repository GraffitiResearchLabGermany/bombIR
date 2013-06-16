package gml4u.drawing;

import gml4u.model.GmlPoint;
import gml4u.model.GmlStroke;
import processing.core.PGraphics;

public abstract class GmlStrokeDrawerBasic extends GmlStrokeDrawer {

	
	/**
	 * GmlStrokeDrawerBasic constructor
	 * @param id - String
	 */
	public GmlStrokeDrawerBasic(String id) {
		super(id);
	}

	/**
	 * Called for each point of the stroke with current and previous point information
	 * Classes extending this class should implement their onw draw(PGraphics, GmlPoint, GmlPoint) method
	 * to do whatever they want with
	 * @param g - PGraphics
	 * @param prev - GmlPoint
	 * @param cur - GmlPoint
	 */
	public abstract void draw (PGraphics g, GmlPoint prev, GmlPoint cur);

	/**
	 * Draws the stroke by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param minTime - float
	 * @param maxTime - float
	 */	
	public final void draw(PGraphics g, GmlStroke stroke, float scale, float minTime, float maxTime) {

		GmlPoint prev = new GmlPoint();
		GmlPoint cur = new GmlPoint();

		for (GmlPoint point: stroke.getPoints()) {
			if (point.time < minTime) continue;
			if (point.time > maxTime) break;

			if (prev.isZeroVector()) {
				prev.set(point.scale(scale));
			}
			cur.set(point.scale(scale));

			draw(g, prev, cur);
			
			prev.set(cur);
		}
	}

}
