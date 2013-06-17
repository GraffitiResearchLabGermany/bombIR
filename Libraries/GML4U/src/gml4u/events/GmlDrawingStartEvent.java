package gml4u.events;

import gml4u.model.Gml;

public class GmlDrawingStartEvent extends GmlEvent {

	public Gml gml;
	
	/**
	 * Creates a new GmlDrawingStartEvent with the given Gml
	 * @param gml - Gml
	 */
	public GmlDrawingStartEvent(Gml gml) {
		this.gml = gml;
	}
}