package gml4u.events;

import java.util.Map;

import gml4u.model.Gml;

public class GmlMultiParsingEvent extends GmlEvent {

	public Map<String, Gml> gmlList;
	
	/**
	 * Creates a new GmlMultiParsingEvent using the given Gml map
	 * @param gmlList - Map<String, Gml> 
	 */
	public GmlMultiParsingEvent(Map<String, Gml> gmlList) {
		this.gmlList = gmlList;
	}
}