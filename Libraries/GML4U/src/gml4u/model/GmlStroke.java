package gml4u.model;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.UUID;

import org.apache.log4j.Logger;

import toxi.geom.AABB;
import toxi.geom.PointCloud;
import toxi.geom.Vec3D;

public class GmlStroke {
	
	private static final Logger LOGGER = Logger.getLogger(GmlStroke.class.getName());

	private boolean isDrawing;
	private int layer;
	private GmlInfo info;
	private GmlBrush brush;
	private List<GmlPoint> points;
	private UUID uuid;
	private float length;
	private AABB boundingBox = AABB.fromMinMax(new Vec3D(0, 0, 0),new Vec3D(1, 1, 1));
	
	/**
	 * Creates a new GmlStroke
	 */
	public GmlStroke() {
		this.isDrawing = true;
		this.layer = Integer.MIN_VALUE;
		this.points = Collections.synchronizedList(new LinkedList<GmlPoint>());
		this.uuid = UUID.randomUUID();
		this.brush = new GmlBrush();
		this.length = 0;
	}

	/**
	 * Creates a new GmlStroke using the given layer
	 * @param layer - int
	 */
	public GmlStroke(int layer) {
		this();
		this.layer = layer;
	}

	/**
	 * Creates a new GmlStroke with the given points
	 * @param points - List<GmlPoint>
	 */
	public GmlStroke(List<GmlPoint> points) {
		this();
		addPoints(points);
	}
	
	/**
	 * Creates a new GmlStroke using the the given layer and points
	 * @param points - List<GmlPoint>
	 * @param layer - int
	 */
	public GmlStroke(List<GmlPoint> points, int layer) {
		this(layer);
		this.points.addAll(points);
	}
	
	/**
	 * Gets the stroke UUID
	 * @return String
	 */
	public String getID() {
		return uuid.toString();
	}

	/**
	 * Returns the stroke's bounding box
	 * @return AABB - boundingBox
	 */
	public AABB getBoundingBox() {
		PointCloud pointCloud = new PointCloud();
		pointCloud.addAll(points);
		return pointCloud.getBoundingBox();
	}

	/**
	 * Returns the length of the stroke
	 * @return float
	 */
	public float getLength() {
		return length;
	}

	/**
	 * Returns the stroke's duration
	 * @return float
	 */
	public float getDuration() {
		if (points.size() > 0) {
			return points.get(points.size()-1).time;
		}
		else {
			return 0;
		}
	}
	
	/**
	 * Returns the stroke's start time (first point's time info)
	 * @return float
	 */
	public float getStartTime() {
		if (points.size() > 0) {
			return points.get(0).time;
		}
		else {
			return 0;
		}
	}
	
	
	
	/**
	 * Returns the number of points in the stroke
	 * @return int
	 */
	public int nbPoints() {
		return points.size();
	}
	
	/**
	 * Gets the brush's style ID
	 * @return String
	 */
	public String getStyle() {
		return (String) brush.get(GmlBrush.UNIQUE_STYLE_ID);
	}
	
	/**
	 * Sets the style to be used by the stroke
	 * @param style - String
	 */
	public void setStyle(String style) {
		brush.set(GmlBrush.UNIQUE_STYLE_ID, style);
	}
	
	/**
	 * Returns the stroke's layer
	 * Note: we won't use the brush info as it may change in a near future.
	 * It makes no sense linking the layer to the brush
	 * @return int
	 */
	public int getLayer() {
		return layer;
	}
	
	/**
	 * Sets the layer value
	 * @param layer - int
	 */
	public void setLayer(int layer) {
		this.layer = layer;
	}
	
	/**
	 * Get isDrawing (true if the stroke shall be drawn)
	 * @return boolean
	 */
	public boolean getIsDrawing() {
		return isDrawing;
	}

	/**
	 * Set isDrawing  (if the stroke shall be drawn or not)
	 * @param b - boolean
	 */
	public void setIsDrawing(boolean b) {
		this.isDrawing = b;
	}

	/**
	 * Gets the GmlBrush
	 * @return GmlBrush
	 */
	public GmlBrush getBrush() {
		return brush;
	}
	
	/**
	 * Sets the GmlBrush
	 * @param brush - GmlBrush
	 */
	public void setBrush(GmlBrush brush) {
		if (null != brush) {
			this.brush = brush;
		}
		else {
			LOGGER.warn("Brush wasn't added. Reason: brush is null");
		}
	}
	
	/**
	 * Gets the GmlInfo
	 * @return GmlInfo
	 */
	public GmlInfo getInfo() {
		return info;
	}
	
	/**
	 * Sets the GmlInfo
	 * @param info - GmlInfo 
	 */
	public void setInfo(GmlInfo info) {
		if (null != info) {
			this.info = info;
		}
		else {
			LOGGER.warn("Info wasn't added. Reason: info is null");
		}
	}
	
	/**
	 * Gets a copy of the first point of the stroke.
	 * Returns null if the stroke is empty
	 * @return GmlPoint
	 */
	public GmlPoint getFirstPoint() {
		if (points.size() >=1) {
			GmlPoint firstPoint = new GmlPoint();
			firstPoint.set(points.get(0));
			return firstPoint;
		}
		return null;
	}
	
	/**
	 * Gets a copy of the last point of the stroke
	 * Returns null if the stroke is empty
	 * @return GmlPoint
	 */
	public GmlPoint getLastPoint() {
		if (points.size() >=1) {
			GmlPoint lastPoint = new GmlPoint();
			lastPoint.set(points.get(points.size()-1));
			return lastPoint;
		}
		return null;
	}

	/**
	 * Returns a copy of the the stroke's points
	 * @return List<GmlPoint>
	 */
	public List<GmlPoint> getPoints() {
		List<GmlPoint> pts = new LinkedList<GmlPoint>();
		if (null != points) {
			pts.addAll(points);
		}
		return pts;
	}

	/**
	 * Returns a filtered list of points based on a given time value
	 * @param time
	 * @return List<GmlPoint>
	 */
	public List<GmlPoint> getPoints(float time) {
		List<GmlPoint> pts = new LinkedList<GmlPoint>();
		for (GmlPoint point : points) {
			if (point.time <= time) {
				pts.add(point);
			}
			else {
				return pts;
			}
		}
		return pts;
	}
	
	/**
	 * Returns a filtered list of points based on a given time interval
	 * @param start - float beginning of time interval
	 * @param end - float end of time interval
	 * @return List<GmlPoint>
	 */
	public List<GmlPoint> getPoints(float start, float end) {
		
		if (end < start) {
			LOGGER.warn("Interval start occurs after interavl end: doing nothing ");
		}
		List<GmlPoint> pts = new LinkedList<GmlPoint>();
		for (GmlPoint point : points) {
			if (point.time >= start && point.time <= end) {
				pts.add(point);
			}
			else {
				return pts;
			}
		}
		return pts;
	}

	/**
	 * Returns the number of points
	 * @return int
	 */
	public int totalPoints() {
		return points.size();
	}

	/**
	 * Replaces the existing points
	 * @param pts - List<GmlPoint>
	 */
	public void replacePoints(List<GmlPoint> pts) {
		clearPoints();
		points.addAll(pts);
	}

	/**
	 * Adds a GmlPoint to the stroke<br/>
	 * Points are added even if outside of the bounding box.<br/>
	 * The normalization util might be run to fix that afterward.<br/>
	 * This allows more flexibility when loading GML which doesn't comply with the 0-1 limit<br/>
	 * @param point - GmlPoint
	 */
	public void addPoint(GmlPoint point) {
		if (null == point) {
			LOGGER.warn("GmlPoint "+ point +" wasn't added. Reason: null");	
			return;
		}
		if (!point.isInAABB(boundingBox)) {
			LOGGER.warn("Inconsistent GmlPoint "+ point +". Reason: outside "+ boundingBox);
		}
		GmlPoint last = getLastPoint();
		if (null != last) {
			length += last.distanceTo(point); 
		}
		points.add(point);
	}
	
	/**
	 * Adds a list of GmlPoint to the stroke
	 * @param pts - List<GmlPoint>
 	 */
	public void addPoints(List<GmlPoint> pts) {
		if (null == pts) {
			LOGGER.warn("GmlPoint list wasn't added. Reason: null");
		}
		else {
			for (GmlPoint pt : pts) {
				addPoint(pt);
			}
		}
	}
	
	/**
	 * Clears all points of the stroke and sets its length to 0
	 */
	public void clearPoints() {
		points.clear();
		length = 0;
	}
}
