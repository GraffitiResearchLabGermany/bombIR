package gml4u.utils;

import gml4u.model.Gml;
import gml4u.model.GmlPoint;
import gml4u.model.GmlStroke;

import java.util.List;

import org.apache.log4j.Logger;

import toxi.geom.AABB;
import toxi.geom.Vec3D;

public class GmlUtils {

	private static final Logger LOGGER = Logger.getLogger(GmlUtils.class.getName());

	/**
	 * Check orientation consistency
	 * Returns true if the given vector complies with the up specs.
	 * It should have only two zeros and one 1 or -1
	 * @param up - Vec3D vector
	 * @return boolean
	 */
	public static boolean isUpValid(Vec3D up) {
		if (Math.abs(up.x) == 1 ^ Math.abs(up.y) == 1 ^ Math.abs(up.z) == 1) {
			return true;
		}
		return false;
	}

	/**
	 * Given a Gml object with a valid up vector
	 * Remaps all points to have a up vector of (0, -1, 0)
	 * @param gml - Gml
	 * @param force - boolean
	 */
	public static void reorient(Gml gml, boolean force) {

		Vec3D defaultUp = new Vec3D(0, -1, 0);
		Vec3D up = null;

		// Check from Gml
		// TODO check if up is always set
		// TODO if (!gml.environment.up.equals(null)) {
		if (null != gml.environment.up) {
			up = new Vec3D(gml.environment.up);
			if (!isUpValid(up)) {
				up.set(defaultUp); 
			}
		}
		// Else force
		else if (force) {
			up = new Vec3D(defaultUp);
		}

		if (!up.equals(null)) {

			List<GmlStroke> strokes = (List<GmlStroke>) gml.getStrokes(); 
			for (GmlStroke stroke: strokes) {
				for(GmlPoint point: stroke.getPoints()) {
					Vec3DUtils.reorient(point, up);
				}
			}
			gml.removeStrokes();
			gml.addStrokes(strokes);
		}

		// Reorient all environment vectors
		//Vec3DUtils.reorient(up, up);
		if (null != gml.environment.origin) {
			Vec3DUtils.reorient(gml.environment.origin, up);
		}
		if (null != gml.environment.offset) {
			Vec3DUtils.reorient(gml.environment.offset, up);
		}


		// Reorient scaling vectors
		Vec3DUtils.reorient(gml.environment.originalOriginShift, up);
		Vec3DUtils.swap(gml.environment.originalAspectRatio, up);
		Vec3DUtils.reorient(gml.environment.normalizedOriginShift, up);
		Vec3DUtils.swap(gml.environment.normalizedAspectRatio, up);

		if (null != gml.environment.realScale) {
			Vec3DUtils.swap(gml.environment.realScale, up);
		}
		if (null != gml.environment.rotation) {
			Vec3DUtils.swap(gml.environment.rotation, up);
		}
		if (null != gml.environment.screenBounds) {
			Vec3DUtils.swap(gml.environment.screenBounds, up);
		}

		gml.environment.up.set(defaultUp);

		// No need to change anything inside brush as it seems
		// to be relative to up.
	}

	/**
	 * Returns the scaling coef to fit the tag within the screen based
	 * on their width/height ratios;
	 * @param screenRatio - Vec3D vector
	 * @param tagRatio - Vec3D vector
	 * @return Vec3D
	 */
	public static Vec3D getScale(Vec3D screenRatio, Vec3D tagRatio) {
		// Check if normalized
		Vec3D scale = new Vec3D(1, 1, 1);
		float coef;
		if (screenRatio.to2DXY().magnitude() < tagRatio.to2DXY().magnitude()) {
			coef = screenRatio.x * screenRatio.y; 
		}
		else {
			coef = tagRatio.x * tagRatio.y; 
		}
		scale.set(coef, coef, coef);
		return scale;
	}

	/**
	 * Checks if the Gml striclty fits into the (0, 0, 0) (1, 1, 1) box
	 * @param gml - Gml
	 * @return boolean
	 */
	public static boolean isNormalized(Gml gml) {
		AABB refBox = AABB.fromMinMax(new Vec3D(0, 0, 0), new Vec3D(1, 1, 1));
		AABB boundingBox = gml.getBoundingBox();

		return boundingBox.equalsWithTolerance(refBox, 0.0000001f);
	}

	/**
	 * Normalizes the Gml to fit within 0-1 for every axis
	 * without keeping the aspect ratio which is stored in
	 * a scaling Vec3D
	 * @param gml - Gml
	 */
	public static void normalize(Gml gml) {

		// TODO check that z is not too large
		// Dustag exceeds 1 for z
		// Remap all points to fit within a min of 0, 0, 0 and a max of 1, 1, 1
		//<name>Graffiti Analysis 2.0: DustTag</name>
		//<version>1.0</version>

		// Case by case normalization
		//Rescale all Z for Graffiti Analysis 2.0: DustTag

		// Get BoundingBox
		AABB boundingBox = gml.getBoundingBox();
		LOGGER.debug("bounding box before scaling"+ boundingBox.getMin() + " " + boundingBox.getMax());

		// Get bounding box min for later substraction 
		Vec3D originShift = boundingBox.getMin();

		// Original aspect ratio of the tag
		Vec3D originalAspectRatio = boundingBox.getExtent().scale(2);

		// Used to scale the tag to a max of 1 on the longest axis
		Vec3D scaling = originalAspectRatio.getReciprocal();

		// Remap all points to fit within a min of 0, 0, 0 and a max of 1, 1, 1
		List<GmlStroke> strokes = (List<GmlStroke>) gml.getStrokes();
		for (GmlStroke stroke : strokes) {
			List<GmlPoint> points = stroke.getPoints();

			//for(GmlPoint point: points) {

			//point.subSelf(originShift);
			//point.scaleSelf(scaling);
			// Fix NaN
			//if (point.x != point.x) point.x = 0;
			//if (point.y != point.y) point.y = 0;
			//if (point.z != point.z) point.z = 0;
			//}

			for(int i=0; i<points.size(); i++) {
				GmlPoint p = points.get(i);
				p.subSelf(originShift);
				p.scaleSelf(scaling);

				// Fix NaN
				if (p.x != p.x || p.y != p.y || p.z != p.z) {
					points.remove(i);
				}
				else {
					points.set(i, p);
				}

			}
			stroke.replacePoints(points);
		}
		gml.replaceStrokes(strokes);

		// Normalize z axis
		// Get max z
		
		boundingBox = gml.getBoundingBox();
		LOGGER.debug("bonding box after rescale"+ boundingBox.getMin() + " " + boundingBox.getMax());
		
		float maxZ = boundingBox.getMax().z; 
		if(maxZ > 1) {
			LOGGER.debug("Z axis too long. Rescaling to fit 0-1");
		// Else remap between 0 and 1
			for (GmlStroke strok : gml.getStrokes()) {
				float nPoints = strok.getPoints().size();
				for (int i=0; i<nPoints; i++) {
					strok.getPoints().get(i).z = strok.getPoints().get(i).z/maxZ;
				} 
			}		
		}
		boundingBox = gml.getBoundingBox();
		LOGGER.debug("bonding box after z axis correction"+ boundingBox.getMin() + " " + boundingBox.getMax());		


		// Store the aspect ratio and origin for reverse scaling
		// Any point can then be rescaled to original value by doing:
		//(point.scaleSelf(originalAspectRatio).addSelf(originShift);
		gml.environment.originalOriginShift.set(originShift);
		gml.environment.originalAspectRatio.set(originalAspectRatio);

		// Normalize (max of 1 for the longest axis) both
		// aspect ratio and origin shift 
		Vec3D normalizer = Vec3DUtils.getNormalizer(originalAspectRatio);
		Vec3D normalizedOriginShift = originShift.scale(normalizer);
		Vec3D normalizedAspectRatio = originalAspectRatio.scale(normalizer);

		gml.environment.normalizedOriginShift.set(normalizedOriginShift);
		gml.environment.normalizedAspectRatio.set(normalizedAspectRatio);
	}

	/**
	 * Ensures there is a minimum/maximum number of points in a Stroke
	 * @param gml - Gml
	 * @param interval - float
	 */
	// TODO lightWeight
	public static void lightWeight(Gml gml, float interval) {

	}

	/**
	 * Makes the Gml fit into a certain duration.<br>
	 * If the <i>keepRatio</i> parameter is true or if the original duration
	 * is zero, then time is split accross all layers, strokes and points.<br/>
	 * If not forced and if the original duration is not zero, then the
	 * time is mapped by keeping the original interval ratio between each point.
	 *
	 * @param gml - Gml
	 * @param duration - float
	 * @param keepRatio - boolean
	 */

	public static void timeBox(Gml gml, float duration, boolean keepRatio) {

		float currentDuration = gml.getDuration();

		// Force an equal interval of time between each point
		if (!keepRatio || currentDuration == 0) {
			int nbPoints = gml.totalPoints();
			float step = duration/nbPoints;
			float currentTime = step;

			// Loop through all layers/strokes/points
			List<GmlStroke> strokes = (List<GmlStroke>) gml.getStrokes();
			for (GmlStroke stroke : strokes) {
				List<GmlPoint> points = stroke.getPoints();
				for(GmlPoint point: points) {
					point.time = currentTime;
					currentTime += step;
				}
				stroke.replacePoints(points);
			}
			gml.replaceStrokes(strokes);
		}

		// Do a mapping between the original duration and the new one
		// by keeping the interval ratio between each point.
		else if (currentDuration > 0) {
			float startTime = gml.getStartTime();
			// Loop through all layers/strokes/points
			List<GmlStroke> strokes = (List<GmlStroke>) gml.getStrokes();
			for (GmlStroke stroke : strokes) {
				List<GmlPoint> points = stroke.getPoints();
				for(GmlPoint point: points) {
					point.time = MappingUtils.map(point.time, startTime, currentDuration, 0.000000001f, duration);						

					if(point.time != point.time) {
						point.time = 0;
					}
				}
				stroke.replacePoints(points);
			}
			gml.replaceStrokes(strokes);
		}
	}

	// TODO stats() get all info about the drawing

}