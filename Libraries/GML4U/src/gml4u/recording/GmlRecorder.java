package gml4u.recording;

import gml4u.model.Gml;
import gml4u.model.GmlBrush;
import gml4u.model.GmlClient;
import gml4u.model.GmlConstants;
import gml4u.model.GmlPoint;
import gml4u.model.GmlStroke;
import gml4u.utils.Vec3DUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.log4j.Logger;

import toxi.geom.AABB;
import toxi.geom.Vec3D;

public class GmlRecorder {
	
	private static final Logger LOGGER = Logger.getLogger(GmlRecorder.class.getName());
	
	public static final float DEFAULT_MIN_STROKE_LENGTH = 0.01f;
	public static final float DEFAULT_MIN_POINTS_DISTANCE = 0.001f;

	private Gml gml;
	private float minStrokeLength;
	private float minPointsDistance;
	private AABB boundingBox = AABB.fromMinMax(new Vec3D(0, 0, 0),new Vec3D(1, 1, 1));
	private ConcurrentHashMap<Integer, GmlStroke> strokes = new ConcurrentHashMap<Integer, GmlStroke>();
	private Vec3D normalizer;
	
	/**
	 * Creates a new GmlRecorder using the given screen size, minimum stroke length and minimum points distance
	 * @param screen - Vec3D (srceen dimensions)
	 * @param minStrokeLength - int (minimum length of the stroke)
	 * @param minPointsDistance - flaot (minimum distance between two points of the same stroke)
	 */
	public GmlRecorder(final Vec3D screen, float minStrokeLength, float minPointsDistance) {
		gml = new Gml();
		initGml(screen);

		this.minStrokeLength = minStrokeLength;
		this.minPointsDistance = minPointsDistance;
	}
	
	/**
	 * Creates a new GmlRecorder using the given screen size and default values for minimum stroke length and minimum points distance
	 * @param screen (srceen dimensions)
	 */
	public GmlRecorder(final Vec3D screen) {
		this(screen, DEFAULT_MIN_STROKE_LENGTH, DEFAULT_MIN_POINTS_DISTANCE);
	}
	
	/**
	 * Initializes the Gml with default values
	 * @param screen - Vec3D vector (screen dimensions) 
	 */
	private void initGml(Vec3D screen) {		
		normalizer = new Vec3D(Vec3DUtils.getNormalized(screen));
		gml.client.set(GmlClient.USERNAME, GmlConstants.DEFAULT_CLIENT_NAME);
		gml.environment.screenBounds = new Vec3D(screen);
	}
	
	/**
	 * Sets the client information to be used. Overrides the default values 
	 * @param client - GmlClient
	 */
	public void setClient(GmlClient client) {
		gml.client = client;
	}
	
	// TODO setEnvironment(GmlEnvironment environment) Useful ?
	// Also resets the screen and normalizer values
	
	/**
	 * Sets the min stroke length. If smaller, a stroke won't be added
	 * @param length - float
	 */
	public void setMinStrokeLength(float length) {
		this.minStrokeLength = length;
	}

	/**
	 * Sets the min points distance. If below, a point won't be added
	 * Used to minimise the number of points
	 * @param distance - float
	 */
	public void setMinPointsDistance(float distance) {
		this.minPointsDistance = distance;
	}
	
	/**
	 * Clears strokes, including those under recording
	 */
	public void clear() {		
		gml.removeStrokes();
		strokes.clear();
	}
	
	/**
	 * Begins the recording of a new GmlStroke<br/>
	 * Note: you must keep track of the sessionID and use the same ID to end the stroke<br/>
	 * otherwise the stroke won't be added to the gml.
	 * @param sessionID - int
	 */
	public void beginStroke(int sessionID) {

		GmlBrush brush = new GmlBrush();
		int layer = 0;
		beginStroke(sessionID, layer, brush);
	}

	/**
	 * Begins the recording of a new GmlStroke<br/>
	 * Note: you must keep track of the sessionID and use the same ID to end the stroke<br/>
	 * otherwise the stroke won't be added to the gml.
	 * @param sessionID - int
	 * @param layer - int
	 */
	public void beginStroke(int sessionID, int layer) {

		GmlBrush brush = new GmlBrush();
		beginStroke(sessionID, layer, brush);
	}


	/**
	 * Begins the recording of a new GmlStroke<br/>
	 * Note: you must keep track of the sessionID and use the same ID to end the stroke<br/>
	 * otherwise the stroke won't be added to the gml.
	 * @param sessionID - int
	 * @param layer - int
	 * @param brush - GmlBrush
	 */
	public void beginStroke(int sessionID, int layer, final GmlBrush brush) {
		
		LOGGER.debug("Start recording");
		GmlStroke stroke = new GmlStroke();
		stroke.setLayer(layer);
		stroke.setBrush(brush);	
		strokes.put(sessionID, stroke);
	}

	/**
	 * Adds a new point to a stroke
	 * The point's coordinates shall be within 0-1 on every axis.
	 * They'll be scaled automatically according to the screen's ratio
	 * @param sessionID - int
	 * @param v - Vec3D vetor (shall be within AABB (0,0,0) -> (1,1,1))
	 */
	public void addPoint(int sessionID, Vec3D v) {
		addPoint(sessionID, v, 0);
	}
	
	/**
	 * Adds a new point to a stroke
	 * The point's coordinates shall be within 0-1 on every axis.
	 * They'll be scaled automatically according to the screen's ratio
	 * @param sessionID - int
	 * @param v - Vec3D vetor (shall be within AABB (0,0,0) -> (1,1,1))
	 * @param time - float
	 */
	public void addPoint(int sessionID, Vec3D v, final float time) {
		addPoint(sessionID, v, time, 1, new Vec3D(), new Vec3D());
	}

	/**
	 * Adds a new point to a stroke
	 * The point's coordinates shall be within 0-1 on every axis.
	 * They'll be scaled automatically according to the screen's ratio
	 * @param sessionID - int
	 * @param v - Vec3D vetor (shall be within AABB (0,0,0) -> (1,1,1))
	 * @param time - float
	 * @param pressure - float
	 * @param rotation - Vec3D
	 * @param direction - Vec3D
	 */
	public void addPoint(int sessionID, Vec3D v, final float time, final float pressure, final Vec3D rotation, final Vec3D direction) {
		LOGGER.debug("Add point");

		// Check bounding box and do not add if outside
		/*
		if (!v.isInAABB(boundingBox)) {
			LOGGER.warn("point skipped : v "+ v + " is outside "+ boundingBox);
		}
		else {
		*/
			v.scaleSelf(normalizer);
			
			// Check is sessionID exists (beginStroke has been called before)
			if (null != strokes.get(sessionID)) {
				
				// Check minimum distance from last point
				if (null != strokes.get(sessionID).getLastPoint()) {
					GmlPoint prev = new GmlPoint();
					prev.set(strokes.get(sessionID).getLastPoint());
					if (prev.distanceTo(v) > minPointsDistance) {
						strokes.get(sessionID).addPoint(new GmlPoint(v, time, pressure, rotation, direction));
					}
					else {
						LOGGER.debug("Skipped, too close from previous point: "+prev.distanceTo(v));
					}
				}
				else { // First point, add it
					strokes.get(sessionID).addPoint(new GmlPoint(v, time, pressure, rotation, direction));
				}
			}
		//}
	}

	/**
	 * Ends recording of a GmlStroke
	 * @param sessionID - int
	 */
	public void endStroke(int sessionID) {
		LOGGER.debug("Stop recording");
		GmlStroke stroke = strokes.get(sessionID);
		// Add the stroke only if significant (at least a certain length)
		if (null != stroke && stroke.getLength() > minStrokeLength) {
			gml.addStroke(stroke);
		}
		strokes.remove(sessionID);
	}

	/**
	 * Ends recording of all GmlStroke
	 */
	public void endStrokes() {
		LOGGER.debug("Stop recording");
		for (int sessionID : strokes.keySet()) {
			GmlStroke stroke = strokes.get(sessionID);
			// Add the stroke only if significant (at least a certain length)
			if (null != stroke && stroke.getLength() > minStrokeLength) {
				gml.addStroke(stroke);
			}			
		}
		strokes.clear();
	}

	/**
	 * Removes the last GmlStroke from the given layer
	 * @param layer
	 */
	public void removeLastStroke(final int layer) {
		gml.removeLastStroke(layer);
	}
	
	/**
	 * Returns  a copy of all GmlStrokes (including those under recording)
	 * @return Collection<GmlStroke>
	 */
	public Collection<GmlStroke> getStrokes() {
		Collection<GmlStroke> strokeList = new ArrayList<GmlStroke>();
		strokeList.addAll(gml.getStrokes());
		strokeList.addAll(strokes.values());
		return strokeList;
	}
	
	// REMOVE LAST STROKE any layer
	
	/**
	 * Returns a copy of the Gml including the strokes under drawing
	 * @return Gml
	 */
	public Gml getGml() {
		Gml gmlCopy = gml.copy();
		gml.addStrokes(strokes.values());
		return gmlCopy;
	}

	/**
	 * Sets the Gml to be used by the GmlRecorder
	 * @param gml - Gml
	 */
	public void setGml(Gml gml) {
		this.gml = gml;
		// TODO test screen or screenbounds consistency
		initGml(gml.environment.screenBounds);
	}
}
