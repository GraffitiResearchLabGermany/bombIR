package gml4u.drawing;

import processing.core.PApplet;
import processing.core.PGraphics;

public abstract class GmlBackground {
	
	private String id;
	private boolean is3D = false;
	
	/**
	 * GmlBackground constructor
	 * @param id - String
	 */
	public GmlBackground(String id) {
		this.id = id;
	}
	
	/**
	 * Gets the GmlBackground ID
	 * @return id - String
	 */
	public String getId() {
		return id;
	}
	
	/**
	 * Sets the GmlBackground ID
	 * @param id - String
	 */
	public void setId(String id) {
		this.id = id;
	}
	
	/**
	 * Returns true if the background can draw in 3D
	 * @return
	 */
	public boolean is3D() {
		return is3D;
	}
	
	/**
	 * Specifies if the background can draw in 3D (false by default)
	 * @param value
	 */
	public void is3D(boolean value) {
		this.is3D = value;
	}


	public abstract void draw(PApplet p);

	public abstract void draw(PGraphics g);
	
}
