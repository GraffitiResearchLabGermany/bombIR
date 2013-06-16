package gml4u.drawing;

import java.util.List;

import gml4u.model.Gml;
import gml4u.model.GmlStroke;
import processing.core.PGraphics;

public abstract class GmlStrokeDrawer {
	
	
	private String id;
	private boolean is3D = false;
	
	/**
	 * GmlStrokeDrawer constructor
	 * @param id - String
	 */
	public GmlStrokeDrawer(String id) {
		this.id = id;
	}
	
	/**
	 * Gets the GmlStrokeDrawer ID
	 * @return id - String
	 */
	public String getId() {
		return id;
	}
	
	/**
	 * Sets the GmlStrokeDrawer ID
	 * @param id - String
	 */
	public void setId(String id) {
		this.id = id;
	}
	
	/**
	 * Returns true if the drawer can draw in 3D
	 * @return
	 */
	public boolean is3D() {
		return is3D;
	}
	
	/**
	 * Specifies if the drawer can draw in 3D (false by default)
	 * @param value
	 */
	public void is3D(boolean value) {
		this.is3D = value;
	}
	
	/**
	 * Draws the Gml by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param gmls - List<Gml>
	 * @param scale - float
	 */
	public final void draw(PGraphics g, List<Gml>  gmls, float scale) {
		drawBg(g);
		for (Gml gml : gmls) {
			for (GmlStroke stroke : gml.getStrokes()) {
				draw(g, stroke, scale, Float.MIN_VALUE, Float.MAX_VALUE);
			}
		}
	}
	
	/**
	 * Draws the Gml by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param gmls - List<Gml>
	 * @param scale - float
	 * @param time - float
	 */
	public final void draw(PGraphics g, List<Gml>  gmls, float scale, float time) {
		drawBg(g);
		for (Gml gml : gmls) {
			for (GmlStroke stroke : gml.getStrokes()) {
				draw(g, stroke, scale, Float.MIN_VALUE, time);
			}
		}
	}
	
	/**
	 * Draws the Gml by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param gml - Gml
	 * @param scale - float
	 * @param minTime - float
	 * @param maxTime - float
	 */
	public final void draw(PGraphics g, List<Gml>  gmls, float scale, float minTime, float maxTime) {
		drawBg(g);
		for (Gml gml : gmls) {
			for (GmlStroke stroke : gml.getStrokes()) {
				draw(g, stroke, scale, minTime, maxTime);
			}
		}
	}
	
	/**
	 * Draws the Gml by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param gml - Gml
	 * @param scale - float
	 */
	public final void draw(PGraphics g, Gml  gml, float scale) {
		for (GmlStroke stroke : gml.getStrokes()) {
			draw(g, stroke, scale, Float.MIN_VALUE, Float.MAX_VALUE);
		}
	}
	
	/**
	 * Draws the Gml by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param gml - Gml
	 * @param scale - float
	 * @param time - float
	 */
	public final void draw(PGraphics g, Gml  gml, float scale, float time) {
		for (GmlStroke stroke : gml.getStrokes()) {
			draw(g, stroke, scale, Float.MIN_VALUE, time);
		}
	}
	
	/**
	 * Draws the Gml by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param gml - Gml
	 * @param scale - float
	 * @param minTime - float
	 * @param maxTime - float
	 */
	public final void draw(PGraphics g, Gml  gml, float scale, float minTime, float maxTime) {
		drawBg(g);
		for (GmlStroke stroke : gml.getStrokes()) {
			draw(g, stroke, scale, minTime, maxTime);
		}
	}
	
	/**
	 * Draws the stroke by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 */
	public final void draw(PGraphics g, GmlStroke  stroke, float scale) {
		draw(g, stroke, scale, Float.MIN_VALUE, Float.MAX_VALUE);
	}
	
	/**
	 * Draws the stroke by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param time - float
	 */
	public final void draw(PGraphics g, GmlStroke  stroke, float scale, float time) {
		draw(g, stroke, scale, Float.MIN_VALUE, time);
	}
	
	/**
	 * Draws the stroke by scaling the points using the given scale 
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param minTime - float
	 * @param maxTime - float
	 */	
	public abstract void draw(PGraphics g, GmlStroke stroke, float scale, float minTime, float maxTime);
	
	/**
	 * Draws in the background of the PGraphics before drawing the strokes
	 * You have to override this method to enable it
	 * @param g - PGraphics
	 */
	public void drawBg(PGraphics g) {
		// DOES NOTHING BY DEFAULT
	}
}
