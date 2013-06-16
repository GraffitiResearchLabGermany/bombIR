package gml4u.model;

import java.util.Map;

import org.apache.log4j.Logger;

public class GmlClient extends GmlGenericContainer {

	private static final Logger LOGGER = Logger.getLogger(GmlClient.class.getName());

	/**
	 * A list of known parameters to be used with setters and getters
	 */
	public static final String NAME 		= "name";
	public static final String VERSION 		= "version";
	public static final String USERNAME 	= "username";
	public static final String PERMALINK 	= "permalink";
	public static final String KEYWORDS 	= "keywords";
	public static final String UNIQUEKEY 	= "uniqueKey";
	public static final String IP 			= "ip";
	public static final String TIME 		= "time";
	public static final String LOCATION 	= "location";
	
	/**
	 * Creates a new GmlClient with default values (name, version, keywords)
	 */
	public GmlClient() {
		checkMandatoryParameters();
	}

	/**
	 * Creates a new GmlClient using the given parameters key/value map
	 * @param map - Map<String, Object>
	 */
	public GmlClient(Map<String, Object> map) {
		this();
		setParameters(map);
	}

	/**
	 * Checks for mandatory parameters and set them with default values if null or empty
	 */
	private void checkMandatoryParameters() {
		LOGGER.debug("Checking mandatory paramaters");
		if (null == get(NAME) || "".equals(get(NAME))) {
			set(NAME, GmlConstants.DEFAULT_CLIENT_NAME);
		}
		if (null == get(VERSION) || "".equals(get(VERSION))) {
			set(VERSION, GmlConstants.DEFAULT_CLIENT_VERSION);
		}
		if (null == get(KEYWORDS) || "".equals(KEYWORDS)) {
			set(KEYWORDS, GmlConstants.DEFAULT_CLIENT_KEYWORDS);
		}	
	}
}
