package gml4u.drawing;

import gml4u.brushes.BoxesDemo;
import gml4u.brushes.CurvesDemo;
import gml4u.brushes.MeshDemo;
import gml4u.model.Gml;
import gml4u.model.GmlStroke;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import processing.core.PApplet;
import processing.core.PGraphics;

public class GmlBrushManager {

	private static final Logger LOGGER = Logger.getLogger(GmlBrushManager.class.getName());
		
	public static final String BRUSH_DEFAULT = CurvesDemo.ID;
	
	private String defaultId;
	private String defaultBgId;
	private PApplet parent = null;
	
	private Map<String, GmlStrokeDrawer> drawers = new HashMap<String, GmlStrokeDrawer>();
	private Map<String, GmlBackground> backgrounds = new HashMap<String, GmlBackground>();
	
	private static final String MISSING_PAPPLET =  "No PApplet passed to the GmlBrushManager. Use \"new GmlBrushManager(this);\" as a constructor";
	private static final String UNKNOWN_DRAWER = "Unknow drawer or no drawer found, using default instead";
	private static final String STYLE_NOT_FOUND = "Style not found, default style wasn't changed";
	private static final String BACKGROUND_NOT_FOUND = "Background not found, default background wasn't changed";
	private static final String DEFAULT_WASNT_CHANGED = "Returning default";
	private static final String RETURNING_DEFAULT = "Returning default";
	private static final String USING_DEFAULT = "Using default";
	private static final String REPLACING_EXISTING = "Name already exists. Replacing it";

	private static final String NULL_GML = "Gml is null";
	private static final String NULL_STROKE = "GmlStroke is null";
	private static final String NO_BRUSH = "GmlStroke has no GmlBrush";
	private static final String CANNOT_REMOVE_DEFAULT_STYLE = "Cannot remove a style when used as default style";
	private static final String CANNOT_REMOVE_DEFAULT_BACKGROUND = "Cannot remove a background when used as default style";
	
	/**
	 * GmlBrushManager constructor
	 */
	public GmlBrushManager() {
		init();
	}
	
	/**
	 * GmlBrushManager constructor
	 */
	public GmlBrushManager(PApplet p) {
		this.parent = p;
		init();
	}
	
	
	/**
	 * Init with default styles and sets defaultStyle
	 */
	private void init() {

		GmlStrokeDrawer curve = new CurvesDemo();
		add(curve);
		GmlStrokeDrawer mesh = new MeshDemo();
		add(mesh);
		GmlStrokeDrawer boxes = new BoxesDemo();
		add(boxes);
		
		defaultId = curve.getId();
	}
	
	/**
	 * Sets the default stroke drawer
	 * @param drawer - GmlStrokeDrawer
	 */
	public void setDefault(GmlStrokeDrawer drawer) {
		add(drawer);
		setDefault(drawer.getId());
	}
	
	/**
	 * Sets the default stroke drawer based on his styleID (if already exists)
	 * @param styleId - String
	 */
	public void setDefault(String styleId) {
		if (drawers.containsKey(styleId)) {
			defaultId = styleId;
		}
		else {
			LOGGER.warn(STYLE_NOT_FOUND + ": " +DEFAULT_WASNT_CHANGED);
		}
	}

	/**
	 * Gets all drawers' Ids as a Collection
	 * @return Collection<String>
	 */
	public Collection<String> getStyles() {
		Collection<String> styles = new ArrayList<String>();
		styles.addAll(this.drawers.keySet());
		return styles;
	}
	
	/**
	 * Returns the amount of drawers registered
	 * @return int
	 */
	public int size() {
		return drawers.size();
	}
	
	/**
	 * Gets a drawer from its index
	 * @param index - int
	 * @return GmlStrokeDrawer
	 */
	public GmlStrokeDrawer get(int index) {
		if (null == drawers.get(index)) {
			LOGGER.warn("Style not found, returning default");
			return drawers.get(defaultId);
		}
		return drawers.get(index);
	}
	
	/**
	 * Gets a drawer from its name
	 * @param styleId - String
	 * @return GmlStrokeDrawer
	 */
	public GmlStrokeDrawer get(String styleId) {
		if (null == drawers.get(styleId)) {
			LOGGER.warn(STYLE_NOT_FOUND + " : "+ RETURNING_DEFAULT);
			return drawers.get(defaultId);
		}
		return drawers.get(styleId);
	}
	
	/**
	 * Gets a drawer id from its index
	 * @param index - int
	 * @return String
	 */
	public String getID(int index) {
		if (index < 0 || index > drawers.size()-1) {
			LOGGER.warn(STYLE_NOT_FOUND + " : " +USING_DEFAULT);
			return defaultId;
		}
		ArrayList<String> keys = new ArrayList<String>();
		keys.addAll(drawers.keySet());
		return keys.get(index);
	}
	
	
	/**
	 * Adds a new stroke drawer.
	 * If another drawer with the same name exists, it will be replaced.
	 * @param drawer - GmlStrokeDrawer
	 */
	public void add(GmlStrokeDrawer drawer) {
		if (null != drawers.get(drawer.getId())) {
			LOGGER.warn(REPLACING_EXISTING + "("+drawer.getId()+")");
		}
		drawers.put(drawer.getId(), drawer);		
	}
	
	/**
	 * Adds a new stroke drawer and changes its ID in the same time
	 * @param id - String
	 * @param drawer - GmlStrokeDrawer
	 */
	public void add(String id, GmlStrokeDrawer drawer) {
		drawer.setId(id);
		add(drawer);
	}
	
	/**
	 * Removes a stroke drawer based on its id
	 * If this style is the default one, it won't be removed and you'll need to set another default one
	 * @param styleId - String
	 */
	public void remove(String styleId) {
		if (drawers.containsKey(styleId)) {
			if (!defaultId.equals(styleId)) {
				drawers.remove(styleId);
			}
			else {
				LOGGER.warn(CANNOT_REMOVE_DEFAULT_STYLE);
			}
		}
		else {
			LOGGER.warn(STYLE_NOT_FOUND + ": " +DEFAULT_WASNT_CHANGED);
		}
	}
	
	/**
	 * Sets the default background
	 * @param background - GmlBackground
	 */
	public void setDefaultBackground(GmlBackground background) {
		add(background);
		setDefaultBackground(background.getId());
	}
	
	/**
	 * Sets the default background based on his background ID (if already exists)
	 * @param backgroundId - String
	 */
	public void setDefaultBackground(String backgroundId) {
		if (drawers.containsKey(backgroundId)) {
			defaultId = backgroundId;
		}
		else {
			LOGGER.warn(BACKGROUND_NOT_FOUND);
		}
	}

	/**
	 * Gets all backgrounds' Ids as a Collection
	 * @return Collection<String>
	 */
	public Collection<String> getBackgrounds() {
		Collection<String> bgs = new ArrayList<String>();
		bgs.addAll(this.backgrounds.keySet());
		return bgs;
	}
	
	/**
	 * Returns the amount of backgrounds registered
	 * @return int
	 */
	public int backgroundsSize() {
		return backgrounds.size();
	}
	
	/**
	 * Gets a background from its index
	 * @param index - int
	 * @return GmlBackground
	 */
	public GmlBackground getBackground(int index) {
		if (null == backgrounds.get(index)) {
			LOGGER.warn(BACKGROUND_NOT_FOUND + " : " +RETURNING_DEFAULT);
			return backgrounds.get(defaultBgId);
		}
		return backgrounds.get(index);
	}
	
	/**
	 * Gets a background from its name
	 * @param styleId - String
	 * @return backgroundId
	 */
	public GmlBackground getBackground(String backgroundId) {
		if (null == backgrounds.get(backgroundId)) {
			LOGGER.warn(BACKGROUND_NOT_FOUND + " : " +RETURNING_DEFAULT);
			return backgrounds.get(defaultId);
		}
		return backgrounds.get(backgroundId);
	}
	
	/**
	 * Gets a background id from its index
	 * @param index - int
	 * @return String
	 */
	public String getBackgroundID(int index) {
		if (index < 0 || index > backgrounds.size()-1) {
			LOGGER.warn(BACKGROUND_NOT_FOUND + " : " + USING_DEFAULT);
			return defaultBgId;
		}
		ArrayList<String> keys = new ArrayList<String>();
		keys.addAll(backgrounds.keySet());
		return keys.get(index);
	}
	
	
	/**
	 * Adds a new background
	 * If another drawer with the same name exists, it will be replaced.
	 * @param drawer - GmlStrokeDrawer
	 */
	public void add(GmlBackground background) {
		if (null != backgrounds.get(background.getId())) {
			LOGGER.warn("Replacing existing drawer with the same name: "+ background.getId());
		}
		backgrounds.put(background.getId(), background);		
	}
	
	/**
	 * Adds a new stroke drawer and changes its ID in the same time
	 * @param id - String
	 * @param drawer - GmlStrokeDrawer
	 */
	public void add(String id, GmlBackground background) {
		background.setId(id);
		add(background);
	}
	
	/**
	 * Removes a stroke drawer based on its id
	 * If this style is the default one, it won't be removed and you'll need to set another default one
	 * @param styleId - String
	 */
	public void removeBackground(String backgroundId) {
		if (backgrounds.containsKey(backgroundId)) {
			if (!defaultBgId.equals(backgroundId)) {
				backgrounds.remove(backgroundId);
			}
			else {
				LOGGER.warn(CANNOT_REMOVE_DEFAULT_BACKGROUND);
			}
		}
		else {
			LOGGER.warn(BACKGROUND_NOT_FOUND);
		}
	}
	
	
	/**
	 * Draws each stroke according to its brush type
	 * @param g - PGraphics
	 * @param gml - Gml
	 * @param scale - float
	 */
	public void draw(PGraphics g, Gml gml, float scale) {
		draw(g, gml, scale, 0, Float.MAX_VALUE);
	}
	
	/**
	 * Draws each stroke according to its brush type and current time
	 * @param g - PGraphics
	 * @param gml - Gml
	 * @param scale - float
	 * @param time - float
	 */
	public void draw(PGraphics g, Gml gml, float scale, float time) {
		draw(g, gml, scale, 0, time);
	}

	/**
	 * Draws each stroke according to its brush type and current time
	 * @param g - PGraphics
	 * @param gml - Gml
	 * @param scale - float
	 * @param timeStart - float
	 * @param timeEnd - float
	 */
	public void draw(PGraphics g, Gml gml, float scale, float timeStart, float timeEnd) {
		if (null == gml) {
			LOGGER.warn(NULL_GML);
		}
		for (GmlStroke currentStroke : gml.getStrokes()) {
			draw(g, currentStroke, scale, timeStart, timeEnd);
		}
	}
	
	/**
	 * Draws the whole stroke according to its brush type
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 */
	public void draw(PGraphics g, GmlStroke stroke, float scale) {
		draw(g, stroke, scale, 0, Float.MAX_VALUE);
	}

	/**
	 * Draws a stroke according to its brush type and current time
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param time - float
	 */
	public void draw(PGraphics g, GmlStroke stroke, float scale, float time) {
		draw(g, stroke, scale, 0, time);
	}
	
	/**
	 * Draws the stroke given a time interval and according to its brush type
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param timeStart - float
	 * @param timeEnd - float
	 */
	public void draw(PGraphics g, GmlStroke stroke, float scale, float timeStart, float timeEnd) {
		if (null != stroke) {
			String style = "";
			if (null == stroke.getBrush()) {
				LOGGER.warn(NO_BRUSH);
			}
			else {
				style = stroke.getBrush().getStyleID();
			}
			draw(g, stroke, scale, timeStart, timeEnd, style);

		}
		else {
			LOGGER.warn(NULL_STROKE);
		}
	}
	
	/**
	 * Draws the whole stroke using a given drawer, bypassing its inner drawer id
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param drawer - drawer id
	 */
	public void draw(PGraphics g, GmlStroke stroke, float scale, String drawer) {
			draw(g, stroke, scale, 0, Float.MAX_VALUE, drawer);
	}

	/**
	 * Draws the stroke up given a time and drawer, bypassing its inner brush style
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param time - float
	 * @param drawer - drawer id
	 */
	public void draw(PGraphics g, GmlStroke stroke, float scale, float time, String drawer) {
		draw(g, stroke, scale, 0, time, drawer);
	}
	
	/**
	 * Draws the stroke given a time interval and drawer, bypassing its inner brush style
	 * @param g - PGraphics
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param timeStart - float
	 * @param timeEnd - float
	 * @param drawer - drawer id
	 */
	public void draw(PGraphics g, GmlStroke stroke, float scale, float timeStart, float timeEnd, String drawer) {
		if (null == drawers.get(drawer)) {
			LOGGER.warn(UNKNOWN_DRAWER);
			drawer = defaultId;
		}
		g.pushStyle();
		drawers.get(drawer).draw(g, stroke, scale, timeStart, timeEnd);
		g.popStyle();
	}
	
	/**
	 * Draws each stroke according to its brush type
	 * @param gml - Gml
	 * @param scale - float
	 */
	public void draw(Gml gml, float scale) {
		if (null != parent) {
			draw(parent.g, gml, scale, 0, Float.MAX_VALUE);
		}
		else {
			LOGGER.warn(MISSING_PAPPLET);
		}
	}
	
	/**
	 * Draws each stroke according to its brush type and current time
	 * @param gml - Gml
	 * @param scale - float
	 * @param time - float
	 */
	public void draw(Gml gml, float scale, float time) {
		if (null != parent) {
			draw(parent.g, gml, scale, 0, time);
		}
		else {
			LOGGER.warn(MISSING_PAPPLET);
		}
	}

	/**
	 * Draws each stroke according to its brush type and current time
	 * @param gml - Gml
	 * @param scale - float
	 * @param timeStart - float
	 * @param timeEnd - float
	 */
	public void draw(Gml gml, float scale, float timeStart, float timeEnd) {
		if (null != parent) {
			if (null == gml) {
				LOGGER.warn(NULL_GML);
			}
			for (GmlStroke currentStroke : gml.getStrokes()) {
				draw(parent.g, currentStroke, scale, timeStart, timeEnd);
			}
		}
		else {
			LOGGER.warn(MISSING_PAPPLET);
		}
	}
	
	/**
	 * Draws the whole stroke according to its brush type
	 * @param stroke - GmlStroke
	 * @param scale - float
	 */
	public void draw(GmlStroke stroke, float scale) {
		if (null != parent) {
			draw(parent.g, stroke, scale, 0, Float.MAX_VALUE);
		}
		else {
			LOGGER.warn(MISSING_PAPPLET);
		}
	}

	/**
	 * Draws a stroke according to its brush type and current time
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param time - float
	 */
	public void draw(GmlStroke stroke, float scale, float time) {
		if (null != parent) {
			draw(parent.g, stroke, scale, 0, time);
		}
		else {
			LOGGER.warn(MISSING_PAPPLET);
		}
	}
	
	/**
	 * Draws the stroke given a time interval and according to its brush type
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param timeStart - float
	 * @param timeEnd - float
	 */
	public void draw(GmlStroke stroke, float scale, float timeStart, float timeEnd) {
		if (null != parent) {
			if (null != stroke) {
				String style = "";
				if (null == stroke.getBrush()) {
					LOGGER.warn(NO_BRUSH);
				}
				else {
					style = stroke.getBrush().getStyleID();
				}
				draw(parent.g, stroke, scale, timeStart, timeEnd, style);
				
			}
			else {
				LOGGER.warn(NULL_STROKE);
			}
		}
		else {
			LOGGER.warn(MISSING_PAPPLET);
		}
	}
	
	/**
	 * Draws the whole stroke using a given drawer, bypassing its inner drawer id
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param drawer - drawer id
	 */
	public void draw(GmlStroke stroke, float scale, String drawer) {
		if (null != parent) {
			draw(parent.g, stroke, scale, 0, Float.MAX_VALUE, drawer);
		}
		else {
			LOGGER.warn(MISSING_PAPPLET);
		}
	}

	/**
	 * Draws the stroke up given a time and drawer, bypassing its inner brush style
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param time - float
	 * @param drawer - drawer id
	 */
	public void draw(GmlStroke stroke, float scale, float time, String drawer) {
		if (null != parent) {
			draw(parent.g, stroke, scale, 0, time, drawer);
		}
		else {
			LOGGER.warn(MISSING_PAPPLET);
		}
	}
	
	/**
	 * Draws the stroke given a time interval and drawer, bypassing its inner brush style
	 * @param stroke - GmlStroke
	 * @param scale - float
	 * @param timeStart - float
	 * @param timeEnd - float
	 * @param drawer - drawer id
	 */
	public void draw(GmlStroke stroke, float scale, float timeStart, float timeEnd, String drawer) {
		if (null != parent) {
			if (null == drawers.get(drawer)) {
				LOGGER.warn(MISSING_PAPPLET);
				drawer = defaultId;
			}
			parent.g.pushStyle();
			drawers.get(drawer).draw(parent.g, stroke, scale, timeStart, timeEnd);
			parent.g.popStyle();
		}
		else {
			LOGGER.warn(MISSING_PAPPLET);
		}
		
	}	
}
