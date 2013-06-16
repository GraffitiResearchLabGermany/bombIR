package gml4u.utils;

import org.apache.log4j.Logger;

import toxi.geom.AABB;
import toxi.geom.ReadonlyVec3D;
import toxi.geom.Vec2D;
import toxi.geom.Vec3D;

public class Vec3DUtils {

	private static final Logger LOGGER = Logger.getLogger(Vec3DUtils.class.getName());

	/**
	 * Returns the smallest axis' size (ie: 0.1f for Vec3D(0.2f, 0.5f, 0.1f))
	 * @param v - vector
	 * @return float
	 */
	public static float getSmallestAxisSize(final Vec3D v) {
		float coef = v.x < v.y ? (v.x < v.z ? v.x : v.z) : (v.y < v.z ? v.y : v.z);
		return coef;		
	}
	
	/**
	 * Returns the longest axis' size (ie: 0.5f for Vec3D(0.2f, 0.5f, 0.1f))
	 * @param v - vector
	 * @return float
	 */
	public static float getLongestAxisSize(final Vec3D v) {
		float coef = v.x > v.y ? (v.x > v.z ? v.x : v.z) : (v.y > v.z ? v.y : v.z);
		return coef;		
	}
	
	/**
	 * Returns a vector whose xyz values are equals to the longest axis
	 * of the provided vector
	 * @param v - vector
	 * @return vector which can be used to scale
	 */
	public static Vec3D getScalingCoef(final Vec3D v) {
		float coef = getLongestAxisSize(v);
		Vec3D vCoef = new Vec3D(coef, coef, coef);
		return vCoef;
	}
	
	/**
	 * Checks if a vector is normalized (fits within 0 and 1 on every axis)
	 * with a tolerance of .0000001
	 * @param v - vector
	 * @return boolean
	 */
	public static boolean isNormalized(Vec3D v) {
		Vec3D min = new Vec3D(-0.0000001f, -0.0000001f, -0.0000001f);
		Vec3D max = new Vec3D(1.0000001f, 1.0000001f, 1.0000001f);
		if (v.isInAABB(AABB.fromMinMax(min, max)))
		return true;
		LOGGER.debug(v+" doesn't fit in "+ min + "/" + max);
		return false;
	}
	
	/**
	 * Returns a normalizing vector to scale the provided vector 
	 * to a max of 1 in either x, y or z axis
	 * @param v - vector
	 * @return vector normalizer
	 */
	public static Vec3D getNormalizer(final Vec3D v) {
		Vec3D vCoef = getScalingCoef(v).getReciprocal();
		return vCoef;
	}
	
	/**
	 * Returns a normalized vector to a max of 1 in either x, y or z axis
	 * @param v - vector
	 * @return normalized vector
	 */
	public static Vec3D getNormalized(final Vec3D v) {
		Vec3D normalized = v.scale(getNormalizer(v));
		return normalized;
	}

	/**
	 * Reorient a Vec3D to match the target up vector according to 
	 * an original up vector and rotation axis
	 * 
	 * @param v - vector
	 * @param centroid
	 * @param up - current up vector
	 * @param upTarget - target up vector
	 */
	public static void reorient(Vec3D v, final Vec3D centroid, final Vec3D up, final Vec3D upTarget) {

		
		if (!Vec3DUtils.isNormalized(v)) {
			LOGGER.debug(v + " is not normalized. Might end up with incorrect rotation");
		}
		
		Vec3D translation = new Vec3D();

		// X
		if (Math.abs(up.x) == 1) {

			// Change the centroid
			
			translation.set(centroid.x, centroid.y, centroid.z);
			
			// X = 1
			if (up.x == 1) {
				transpose(v, translation, Vec3D.Z_AXIS, (float) -Math.PI/2);
			}
			// X = -1
			else {
				transpose(v, translation, Vec3D.Z_AXIS, (float) Math.PI/2);
			}
		}
		// Y
		else if (Math.abs(up.y) == 1) {

			translation.set(centroid.x, centroid.y, centroid.z);
			
			// Y = 1
			if (up.y == 1) {
				transpose(v, translation, Vec3D.Z_AXIS, (float) Math.PI);
			}
			// Y = -1
			// Do nothing
		}
		// Z
		else {

			// Z = 1
			if (up.z == 1) {
				v.addSelf(new Vec3D(0, 0, -centroid.z*2));
				translation.set(0, 0, 0f);
				transpose(v, translation, Vec3D.X_AXIS, (float) Math.PI/2);
			}
			//Z = -1
			else {
				translation.set(centroid.x, 0, centroid.z);
				transpose(v, translation, Vec3D.Y_AXIS, (float) Math.PI);
				translation.set(0, 0, 0);
				transpose(v, translation, Vec3D.X_AXIS, (float) Math.PI/2);
				v.addSelf(0, 1f, 0);		
			}
		}
	}
	
	/**
	 * Reorient a Vec3D using a target up vector of 0, -1, 0 
	 * and rotation around .5, .5, .5 
	 * 
	 * @param v - vector
	 * @param up - current up vector
	 */

	public static void reorient(Vec3D v, final Vec3D up) {
		
		Vec3D centroid = new Vec3D(0.5f, 0.5f, 0.5f);
		Vec3D upTarget = new Vec3D(0, -1, 0);
		
		reorient(v, centroid, up, upTarget);	
	}


	
	/**
	 * Transpose x,y,z using the given rotation around the given axis
	 * @param v - vector
	 * @param shift - vector (center of the rotation)
	 * @param xAxis
	 * @param rotation - rotation value
	 */
	public static void transpose(Vec3D v, final Vec3D shift, final ReadonlyVec3D xAxis, final float rotation) {
		v.subSelf(shift);
		v.rotateAroundAxis(xAxis, rotation);
		v.addSelf(shift);
	}

	
	/**
	 * Swaps the axis according to up
	 * @param v vector
	 * @param up
	 */
	public static void swap(Vec3D v, final Vec3D up) {

		if (Math.abs(up.x) ==1) {
			float tmp = v.x;
			v.x = v.y;
			v.y = tmp;
		}
		
		//  y = up, nothing to do
		// else if (Math.abs(up.y) == 1) {
		// }
		
		else if (Math.abs(up.z) == 1) {
			float tmp = v.z;
			v.z = v.y;
			v.y = tmp;
		}
	}
	
	/**
	 * Returns the best graff scale, based on screen dimensions and ratio 
	 * @param containerSize
	 * @param aspectRatio
	 * @param ratio
	 * @return vector
	 */
	public static Vec3D getFitInside2DXY(final Vec3D containerSize, final Vec3D aspectRatio, final float ratio) {
		
		float coef = 1;
		Vec2D container2D = containerSize.to2DXY();

		// Normalize for comparison
		Vec2D containerAspectRatio2D = Vec2DUtils.getNormalized(container2D);
		Vec2D aspectRatio2D = Vec2DUtils.getNormalized(aspectRatio.to2DXY());
		
		LOGGER.debug("container2D "+container2D);
		LOGGER.debug("containerAspectRatio2D" +containerAspectRatio2D);
		LOGGER.debug("aspectRatio2D" +aspectRatio2D);

		// Portrait
		if (Math.abs(containerAspectRatio2D.x - aspectRatio2D.x) <= .0000001f) {
			if (containerAspectRatio2D.y >= aspectRatio2D.y) {
				coef = containerSize.x;
			}
			else {
				coef = containerSize.x * (containerAspectRatio2D.y / aspectRatio2D.y);
			}
		}
		// Landscape
		else if (Math.abs(containerAspectRatio2D.y - aspectRatio2D.y) <= .0000001f) {
			if (containerAspectRatio2D.x >= aspectRatio2D.x) {
				coef = containerSize.y;
			}
			else {
				coef = containerSize.y * (containerAspectRatio2D.x / aspectRatio2D.x);
			}
		}
		// Different orientation
		// screen x && tag y == 1
		else if (Math.abs(containerAspectRatio2D.x - aspectRatio2D.y) <= .0000001f) {
			coef = containerSize.y;
		}
		// screen y && tag x == 1
		else {
			coef = containerSize.x;
		}
		coef *= ratio;
		
		return aspectRatio.scale(coef);
	}
	
	// TODO getFitInside3D()
	
}
