package gml4u.utils;

import toxi.geom.Vec2D;

public class Vec2DUtils {
	
	//private static final Logger LOGGER = Logger.getLogger(Vec2DUtils.class.getName());

	/**
	 * Returns the smallest axis' size (ie: 0.1f for Vec2D(0.2f, 0.1f))
	 * @param v - vector
	 * @return float
	 */
	public static float getSmallestAxisSize(Vec2D v) {
		float coef = v.x < v.y ? v.x : v.y;
		return coef;		
	}
	
	/**
	 * Returns the longest axis' size (ie: 0.5f for Vec2D(0.2f, 0.5f))
	 * @param v - vector
	 * @return float
	 */
	public static float getLongestAxisSize(Vec2D v) {
		float coef = v.x > v.y ? v.x : v.y;
		return coef;		
	}
	
	/**
	 * Returns a vector whose xy values are equals to the longest axis
	 * of the provided vector
	 * @param v - vector
	 * @return Vec2D
	 */
	public static Vec2D getScalingCoef(Vec2D v) {
		float coef = v.x > v.y ? v.x : v.y;
		Vec2D vCoef = new Vec2D(coef, coef);
		return vCoef;
	}
	
	/**
	 * Returns a normalizing vector to scale the provided vector 
	 * to a max of 1 in either x or y axis
	 * @param v - vector
	 * @return Vec2D
	 */
	public static Vec2D getNormalizer(Vec2D v) {
		Vec2D vCoef = getScalingCoef(v).getReciprocal();
		return vCoef;
	}
	
	/**
	 * Returns a normalized vector to a max of 1 in either x or y axis
	 * @param v - vector
	 * @return Vec2D
	 */
	public static Vec2D getNormalized(Vec2D v) {
		Vec2D normalized = v.scale(getNormalizer(v));
		return normalized;
	}
}
