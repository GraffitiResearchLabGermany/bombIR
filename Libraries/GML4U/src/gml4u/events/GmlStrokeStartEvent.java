package gml4u.events;

import gml4u.model.GmlStroke;

public class GmlStrokeStartEvent extends GmlEvent {

	public GmlStroke stroke;
	
	/**
	 * Creates a new GmlStrokeEndEvent using the given stroke
	 * @param stroke - GmlStroke
	 */
	public GmlStrokeStartEvent(GmlStroke stroke) {
		this.stroke = stroke;
	}
}