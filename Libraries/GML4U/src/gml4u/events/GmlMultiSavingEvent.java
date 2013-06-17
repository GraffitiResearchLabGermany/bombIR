package gml4u.events;

import java.util.HashMap;
import java.util.Map;

public class GmlMultiSavingEvent extends GmlEvent {
	
	public Map<String, Boolean> locations = new HashMap<String, Boolean>();
	
	/**
	 * Creates a new GmlMultiSavingEvent using the given results (location, successful)
	 * @param locations - Map<String, Boolean>
	 */
	public GmlMultiSavingEvent(Map<String, Boolean> locations) {
		this.locations.putAll(locations);
	}
}