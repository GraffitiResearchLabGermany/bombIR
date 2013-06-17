package gml4u.model;

import gml4u.drawing.GmlBrushManager;

import java.util.Map;


import org.apache.log4j.Logger;

public class GmlBrush extends GmlGenericContainer {

	private static final Logger LOGGER = Logger.getLogger(GmlBrush.class.getName());
	
	/**
	 * A list of known parameters to be used with setters and getters
	 */	
	public static final String NAME 					= "name";
	public static final String MODE						= "mode";
	public static final String UNIQUE_STYLE_ID 			= "uniqueStyleID";
    public static final String SPEC 					= "spec";
    public static final String WIDTH 					= "width";
    public static final String SPEED_TO_WIDTH_RATIO 	= "speedToWidthRatio";
    public static final String DRIP_AMNT 				= "dripAmnt";
    public static final String DRIP_SPEED 				= "dripSpeed";
    public static final String COLOR					= "color";
    public static final String DRIP_VEC_RELATIVE_TO_UP 	= "dripVecRelativeToUp";
    public static final String LAYER_ABSOLUTE			= "layerAbsolute";
    public static final String LAYER_RELATIVE			= "layerRelative";
    
	/**
	 * Creates a new GmlBrush with the given uniqueStyleID
	 */
	public GmlBrush() {
		checkMandatoryParameters();
	}

	
	/**
	 * Creates a new GmlBrush using the given parameters key/value map
	 * @param map - Map<String, Object>
	 */
	public GmlBrush(Map<String, Object> map) {
		this();
		setParameters(map);
	}

	/**
	 * 	Make sure that we have at least a <b><i>uniqueStyleID</i></b> parameter
	 */
	private void checkMandatoryParameters() {
		if (null == get(GmlBrush.UNIQUE_STYLE_ID) || "".equals(get(GmlBrush.UNIQUE_STYLE_ID))) {
			LOGGER.debug("No brush defined, using default Brush instead");
			set(GmlBrush.UNIQUE_STYLE_ID, GmlBrushManager.BRUSH_DEFAULT);
		}
	}

	/**
	 * Returns the brush's styleID or returns default value if not found
	 * @return String
	 */
	public String getStyleID() {
		String uniqueStyleID = getString("uniqueStyleID");
		if (null == uniqueStyleID || "".equals(uniqueStyleID)) {
			uniqueStyleID = GmlBrushManager.BRUSH_DEFAULT;
			LOGGER.warn("uniqueStyleID is null or empty, using default instead");
			return uniqueStyleID;
		}
		return uniqueStyleID;
	}
	
	/**
	 * Merges two brushes
	 * @param brush - GmlBrush
	 */
	public void merge(final GmlBrush brush) {
		// TODO set priority from one over the other
		// TODO check brush type prior to merge or have falg to force
		brush.setParameters(this.getParameters());
		setParameters(brush.getParameters());
	}
}