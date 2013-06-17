package gml4u.model;

import java.awt.Color;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import toxi.geom.Vec3D;

public abstract class GmlGenericContainer {

	private static final Logger LOGGER = Logger.getLogger(GmlGenericContainer.class.getName());
	
	private Map<String, Object> map = new HashMap<String, Object>();;
	
	/**
	 * Hook method, called after each parameter modification (add, del, update)<br/>
	 * Does nothing by default<br/>
	 * Override this method to perform checks for mandatory parameter<br/>
	 */
	private void checkMandatoryParameters() {
	}
	
	/**
	 * Sets a property
	 * @param name - String
	 * @param o - any Object
	 */
	public final void set(String name, Object o) {
		map.put(name, o);
		checkMandatoryParameters();
	}
	
	/**
	 * Gets the given parameter's value as an Object
	 * Returns null if parameter doesn't exits
	 * @param param - String
	 * @return Object
	 */
	public final Object get(String param)  {
		try {
			return map.get(param);
		}
		catch (Exception e) {
			LOGGER.warn("Returning null. Reason: "+ param +" doesn't exist");
			return null;
		}
	}
	
	/**
	 * Removes the given parameter entry
	 * @param param - String
	 */
	public final void remove(String param)  {
		try {
			map.remove(param);
		}
		catch (Exception e) {
			LOGGER.warn("Object wasn't removed. Reason: "+ param +" doesn't exist");
		}
	}
	
	/**
	 * Gets the given parameter's value as a Vec3D vector
	 * Returns null if the parameter doesn't exist or is not a Vec3D
	 * @param param - String
	 * @return Vec3D
	 */
	public final Vec3D getVec3D(String param) {
		try {
			Vec3D v = (Vec3D) map.get(param);
			return v;
		}
		catch (Exception e) {
			LOGGER.warn("Returning null. Reason: "+ param +" value is not a Vec3D");
			return null;
		}
	}

	/**
	 * Gets the given parameter's value as a String
	 * Returns null if the parameter doesn't exist or is not a String
	 * @param param - String
	 * @return String
	 */
	public final String getString(String param) {
		try {
			String s = (String) map.get(param);
			return s;
		}
		catch (Exception e) {
			LOGGER.warn("Returning null. Reason: "+ param +" value is not a String");
			return null;
		}
	}
	
	/**
	 * Gets the given parameter's value as a Float
	 * Returns null if the parameter doesn't exist or is not a Float
	 * @param param - String
	 * @return Float
	 */
	public final Float getFloat(String param) {
		try {
			Float f = (Float) map.get(param);
			return f;
		}
		catch (Exception e) {
			LOGGER.warn("Returning null. Reason: "+ param +" value is not a Float");
			return null;
		}
	}

	/**
	 * Gets the given parameter's value as an Integer
	 * Returns null if parameter doesn't exist or is not an Integer
	 * @param param - String
	 * @return Integer
	 */
	public final Integer getInt(String param) {
		try {
			Integer i = (Integer) map.get(param);
			return i;
		}
		catch (Exception e) {
			LOGGER.warn("Returning null. Reason: "+ param +" value is not an Integer");
			return null;
		}
	}

	/**
	 * Gets the given parameter's value as a Long
	 * Returns null if parameter doesn't exist or is not a Long
	 * @param param - String
	 * @return Long
	 */
	public final Long getLong(String param) {
		try {
			Long l = (Long) map.get(param);
			return l;
		}
		catch (Exception e) {
			LOGGER.warn("Returning null. Reason: "+ param +" value is not a Long");
			return null;
		}
	}

	/**
	 * Gets the given parameter's value as a Color
	 * Returns null if parameter doesn't exist or is not a Color
	 * @param param - String
	 * @return Color
	 */
	public final Color getColor(String param) {
		try {
			Color c = (Color) map.get(param);
			return c;
		}
		catch (Exception e) {
			LOGGER.warn("Returning null. Reason: "+ param +" value is not a Color");
			return null;
		}
	}

	/**
	 * Replaces parameters using the given parameter map
	 * @param map - Map<String, Object>
	 */
	public final void replaceParameters(Map<String, Object> map) {
		map.clear();
		setParameters(map);
	}

	/**
	 * Sets parameters using th given parameter map<br/>
	 * It will override any existing parameter where parameter names are identical
	 * @param map - Map<String, Object>
	 */
	public final void setParameters(Map<String, Object> map) {
		this.map.putAll(map);
		checkMandatoryParameters();
	}
		
	/**
	 * Returns a copy of the parameters 
	 * @return Map<String, Object>
	 */
	public final Map<String, Object> getParameters() {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.putAll(map);
		return params;
	}
}