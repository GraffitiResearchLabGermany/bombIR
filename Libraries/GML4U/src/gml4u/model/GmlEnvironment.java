package gml4u.model;

import org.apache.log4j.Logger;

import toxi.geom.Vec3D;

public class GmlEnvironment {

	private static final Logger LOGGER = Logger.getLogger(GmlEnvironment.class.getName());
	
	public Vec3D offset;
	public Vec3D rotation;
	public Vec3D up;
	public Vec3D screenBounds;
	public float screenScale;
	public Vec3D origin;
	public Vec3D realScale;
	public String realScaleUnit;
	
	// Not GML spec
	public Vec3D originalOriginShift;
	public Vec3D originalAspectRatio;
	public Vec3D normalizedOriginShift;
	public Vec3D normalizedAspectRatio;
	
	/**
	 * Creates a new GmlEnvironment using the given screenBounds and default values
	 */
	public GmlEnvironment(Vec3D screenBounds) {
		
		this.screenBounds = new Vec3D(screenBounds);
		
		// Use default values
		up = new Vec3D(GmlConstants.DEFAULT_ENVIRONMENT_UP);
		
		originalOriginShift = new Vec3D(0, 0, 0);
		originalAspectRatio = new Vec3D(1, 1, 1);
		normalizedOriginShift = new Vec3D(0, 0, 0);
		normalizedAspectRatio = new Vec3D(1, 1, 1);	
	}
	
	/**
	 * Sets a Vec3D value
	 * @param name - String
	 * @param v - Vector
	 */
	// TODO set(String name, Object value) + tests instanceof
	public void set(String name, Vec3D v)  {
		if (name.equalsIgnoreCase("offest")) 			this.offset = v;
		else if (name.equalsIgnoreCase("rotation")) 	this.rotation = v;
		else if (name.equalsIgnoreCase("up")) 			this.up = v;
		else if (name.equalsIgnoreCase("screenBounds")) this.screenBounds = v;
		else if (name.equalsIgnoreCase("origin"))		this.origin = v;
		else if (name.equalsIgnoreCase("realScale")) 	this.origin = v;
		else {
			LOGGER.warn("Skipping "+name+": field doesn't exist");
		}
	}
	
	/**
	 * Sets a String value
	 * @param name - String
	 * @param value - String
	 */
	public void set(String name, String value)  {
		if (name.equalsIgnoreCase("realScaleUnit")) 	this.realScaleUnit = value;
		else if (name.equalsIgnoreCase("screenScale"))	this.screenScale = Float.parseFloat(value);
		else {
			LOGGER.warn("Skipping "+name+": field doesn't exist");
		}
	}
}