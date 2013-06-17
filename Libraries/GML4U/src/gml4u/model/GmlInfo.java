package gml4u.model;

import java.util.Map;

public class GmlInfo extends GmlGenericContainer {

	//private static final Logger LOGGER = Logger.getLogger(GmlInfo.class.getName());

	/**
	 * A list of known parameters to be used with setters and getters
	 */	
	// public static final String XXX = "";
	
	/**
	 * Creates a new GmlInfo
	 */
	public GmlInfo() {
	}
	
	/**
	 * Creates a new GmlInfo using the given parameters key/value map
	 * @param map - Map<String, Object>
	 */
	public GmlInfo(Map<String, Object> map) {
		this();
		setParameters(map);
	}
}