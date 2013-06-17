package gml4u.model;

import toxi.geom.Vec3D;

public class GmlPoint extends Vec3D {

	//private static final Logger LOGGER = Logger.getLogger(GmlPoint.class.getName());
	
	// Leaving this public as Vec3D does for x, y, z
	public float time;
	public Vec3D rotation;
	public Vec3D direction;
	public float preasure;

	public static float DEFAULT_PRESSURE = 1;
	
	/**
	 * Creates a new GmlPoint
	 */
	public GmlPoint() {
		this(new Vec3D(), 0);
	}

	/**
	 * Creates a new GmlPoint using the given vector and time
	 * @param v - Vec3D
	 * @param time - float
	 */
	public GmlPoint(Vec3D v, float time) {
		this(v, time, 0, new Vec3D(), new Vec3D());
	}
	
	/**
	 * Creates a new GmlPoint using the given vector, time, pressure, rotation and direction
	 * @param v - Vec3D
	 * @param time - float
	 * @param pressure - float
	 * @param rotation - Vec3D
	 * @param direction - Vec3D
	 */
	public GmlPoint(Vec3D v, float time, float pressure, Vec3D rotation, Vec3D direction) {
		super(v);
		this.time = time;
		this.preasure = pressure;
		this.rotation = new Vec3D(rotation);
		this.direction = new Vec3D(direction);
	}
	
	/**
	 * Creates a new GmlPoint from another GmlPoint
	 * @param point - GmlPoint
	 */
	public GmlPoint(GmlPoint point) {
		super.set(point);
		this.time = point.time;
		this.preasure = point.preasure;
		this.rotation = new Vec3D(point.rotation);
		this.direction = new Vec3D(point.direction);
	}
	
	/**
	 * Sets the GmlPoint using another GmlPoint
	 * @param point - GmlPoint
	 */
	public void set(GmlPoint point) {
		super.set(point);
		this.time = point.time;
		this.preasure = point.preasure;
		this.rotation = new Vec3D(point.rotation);
		this.direction = new Vec3D(point.direction);
	}
	
	/**
	 * Gets the GmlPoint info as a String
	 * @return String
	 */
	public String toString() {
		return "v"+super.toString()+" t{"+time+"} preasure {"+preasure+"} rotation "+rotation+"} direction "+direction;
	}
}