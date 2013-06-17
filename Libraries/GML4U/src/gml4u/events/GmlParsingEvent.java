package gml4u.events;

import gml4u.model.Gml;

public class GmlParsingEvent extends GmlEvent {

	public Gml gml;
	
	/**
	 * Creates a new GmlParsingEvent using the given Gml
	 * @param gml - Gml
	 */
	public GmlParsingEvent(Gml gml) {
		this.gml = gml;
	}
}