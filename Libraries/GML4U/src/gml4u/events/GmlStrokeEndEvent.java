package gml4u.events;

import gml4u.model.GmlStroke;

public class GmlStrokeEndEvent extends GmlEvent {

	public GmlStroke stroke;
	
	/**
	 * Creates a new GmlStrokeEndEvent using the given stroke
	 * @param stroke
	 */
	public GmlStrokeEndEvent(GmlStroke stroke) {
		this.stroke = stroke;
	}
}