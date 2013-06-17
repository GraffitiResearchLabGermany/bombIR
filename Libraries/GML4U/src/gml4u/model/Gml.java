package gml4u.model;

import gml4u.utils.FileUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.log4j.Logger;

import toxi.geom.AABB;
import toxi.geom.PointCloud;
import toxi.geom.Vec2D;
import toxi.geom.Vec3D;

public class Gml {

	private static final Logger LOGGER = Logger.getLogger(Gml.class.getName());

	public static final String FILENAME ="filename";
	
	public GmlEnvironment environment;
	public GmlClient client;
	private SortedMap<Integer, ArrayList<GmlStroke>> layers = new TreeMap<Integer, ArrayList<GmlStroke>>();

	/**
	 * Creates a new Gml using the given screenBounds
	 * @param screenBounds - Vec3D
	 */
	public Gml(Vec3D screenBounds) {
		client = new GmlClient();
		environment = new GmlEnvironment(screenBounds);
		setFileName("");
	}

	/**
	 * Creates a new Gml with a default screenBounds x,y,z = 1, 1, 1
	 */
	public Gml() {
		this(new Vec3D(1, 1, 1));
	}
	
	public void setFileName(String name) {
		if (null == name || name.equals("")) {
			name = FileUtils.generateRandomName();
		}
		this.client.set(FILENAME, name);
	}
	
	/**
	 * Gets the filename set for this Gml
	 * If not already set, a random one is automatically generated 
	 * @return
	 */
	public String getFileName() {
		String name = "";
		if (null == client.getString(FILENAME)) {
			name = FileUtils.generateRandomName();
			setFileName(name);
		}
		else {
			name = client.getString(FILENAME); 
		}
		return name;
	}

	/**
	 * Returns a copy of all strokes
	 * @return Collection<GmlStroke>
	 */
	public Collection<GmlStroke> getStrokes() {
		Collection<GmlStroke> strokes = new ArrayList<GmlStroke>();
		Set<Integer> keys = layers.keySet();
		for (Integer key : keys) {
			strokes.addAll(getStrokes(key));
		}
		return strokes;		
	}

	/**
	 * Returns a copy of all strokes for a given layer
	 * @param layer - int
	 * @return Collection<GmlStroke>
	 */
	public Collection<GmlStroke> getStrokes(int layer) {
		Collection<GmlStroke> strokes = new ArrayList<GmlStroke>();
		if (null != layers.get(layer)) {
			strokes.addAll(layers.get(layer));
		}
		return strokes;
	}

	
	// TODO getStrokes(float time)
	
	// TODO getStrokes(float startTime, float endTime)

	// TODO getFirstPoint()

	// TODO getFirstPoint(float time)

	// TODO getLastPoint()	
	
	// TODO getLastPoint(float time)
	
	/**
	 * Returns all layers' Ids
	 * @return Collection<Integer>
	 */
	public Collection<Integer> getLayerIds() {
		Collection<Integer> keys = new ArrayList<Integer>();
		keys.addAll(layers.keySet());
		return keys;
	}

	/**
	 * Checks if the given layer exists and adds it if needed 
	 * @param layer - int
	 */
	private void addLayer(int layer) {
		if (!layers.containsKey(layer)) {
			ArrayList<GmlStroke> strokeList = new ArrayList<GmlStroke>();
			layers.put(layer, strokeList);
		}
	}

	/**
	 * Adds a new stroke
	 * @param stroke - GmlStroke
	 */
	public void addStroke(GmlStroke stroke) {
		if (null != stroke && stroke.totalPoints() > 0) { 
			int layer = stroke.getLayer();
			addLayer(layer);
			layers.get(layer).add(stroke);
		}
		else {
			LOGGER.warn("Stroke wasn't added. Reason: Null or empty stroke");
		}
	}

	/**
	 * Adds new strokes
	 * @param strokes - Collection<GmlStroke>
	 */
	public void addStrokes(Collection<GmlStroke> strokes) {
		for(GmlStroke stroke : strokes) {
			addStroke(stroke);
		}
	}

	/**
	 * Replaces all strokes with new ones
	 * @param strokes - Collection<GmlStroke>
	 */
	public void replaceStrokes(Collection<GmlStroke> strokes) {
		removeStrokes();
		addStrokes(strokes);
	}

	/**
	 * Removes all strokes from a specific layer
	 * @param layer - int
	 */
	public void removeStrokes(int layer) {
		layers.remove(layer);
	}

	/**
	 * Removes all strokes
	 */
	public void removeStrokes() {
		layers.clear();
	}

	/**
	 * Removes the last stroke from a specific layer
	 * @param layer - int
	 */
	public void removeLastStroke(int layer) {
		try {
			layers.get(layer).remove(layers.get(layer).size()-1);
			// Also remove the layer if it doesn't contain any stroke
			if (layers.get(layer).size() == 0) {
				layers.remove(layer);
			}
		}
		catch (NullPointerException e) {
			// Just do nothing
		}
	}

	/**
	 * Gets the bounding rectangle of the Gml (includes all strokes)
	 * @return Vec2D
	 */
	public Vec2D getBoundingRect() {
		Vec3D boundingBox = getBoundingBox().getExtent().scale(2);
		return boundingBox.to2DXY();
	}

	/**
	 * Gets the bounding box of the Gml (including all strokes);
	 * @return AABB
	 */
	public AABB getBoundingBox() {

		PointCloud pointCloud = new PointCloud();
		ArrayList<Vec3D> list = new ArrayList<Vec3D>();

		// TODO choose what to return (0 or center) when there is no stroke
		for (GmlStroke stroke : getStrokes()) {
			AABB bounds = stroke.getBoundingBox();
			list.add(bounds.getMin());
			list.add(bounds.getMax());
		}

		pointCloud.addAll(list);
		return pointCloud.getBoundingBox();
	}

	/**
	 * Gets the centroid of the Gml (includes all strokes)
	 * @return Vec3D
	 */
	public Vec3D getCentroid() {
		AABB boundingBox = getBoundingBox();
		return boundingBox.getMin().add(boundingBox.getExtent());
	}

	/**
	 * Gets the duration
	 * @return float 
	 */
	public float getDuration() {
		float duration = 0;
		for (GmlStroke stroke : getStrokes()) {
			float tmpDuration = stroke.getDuration();
			if (tmpDuration > duration) {
				duration = tmpDuration;
			}
		}
		return duration;
	}


	/**
	 * Gets the start time of the drawing
	 * @return float 
	 */
	public float getStartTime() {
		float start = Float.MAX_VALUE;
		for (GmlStroke stroke : getStrokes()) {
			float tmpStart = stroke.getStartTime();
			if (tmpStart < start) {
				start = tmpStart;
			}
		}
		if (start == Float.MAX_VALUE) {
			start = 0;
		}
		return start;
	}
	
	/**
	 * Returns the number of layers
	 * @return int
	 */
	public int totalLayers() {
		return layers.size();
	}

	/**
	 * Returns the total number of strokes
	 * @return int
	 */
	public int totalStrokes() {
		return getStrokes().size();
	}

	/**
	 * Returns the total number of strokes in the given layer
	 * @return int
	 */
	public int totalStrokes(int layer) {
		return getStrokes(layer).size();
	}

	/**
	 * Returns the total number of points including all layers
	 * @return int
	 */
	public int totalPoints() {
		int totalNbPoints = 0;

		for (GmlStroke stroke : getStrokes()) {
			totalNbPoints += stroke.nbPoints();
		}
		return totalNbPoints;
	}

	/**
	 * Returns the total number of points in the given layer
	 * @return int
	 */
	public int totalPoints(int layer) {
		int totalNbPoints = 0;
		for (GmlStroke stroke : getStrokes(layer)) {
			totalNbPoints += stroke.nbPoints();
		}
		return totalNbPoints;
	}

	/**
	 * Returns a copy of the Gml
	 * @return Gml
	 */
	public Gml copy() {
		Gml newGml = new Gml();
		newGml.client = this.client;
		newGml.environment = this.environment;
		newGml.layers.putAll(this.layers);
		return newGml;
	}
}