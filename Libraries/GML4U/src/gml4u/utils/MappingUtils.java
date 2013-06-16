package gml4u.utils;

public class MappingUtils {

	/**
	 * Convenience function used to map a variable from one
	 * coordinate space to another.
	 * 
	 * Equivalent to the Processing PApplet map function
	 * Used to remove dependency to Processing core.jar
	 * 
	 * @param x - float source
	 * @param minS - float mini for source range
	 * @param maxS - float maxi for source range
	 * @param minT - float mini for target range
	 * @param maxT - float maxi for target ragne
	 * @return float
	 */
	public static float map(float x, float minS, float maxS, float minT, float maxT) {
		return minT + ((x-minS) / (maxS-minS)) * (maxT - minT);		
	}
}