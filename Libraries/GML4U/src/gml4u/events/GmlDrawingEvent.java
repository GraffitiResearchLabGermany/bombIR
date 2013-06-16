package gml4u.events;

import gml4u.model.GmlStroke;

public class GmlDrawingEvent extends GmlEvent {

	public GmlStroke stroke;
	public float timeMin;
	public float timeMax;
	
	/**
	 * Creates a new GmlDrawingEvent with the given stroke and time interval
	 * @param stroke
	 * @param timeMin
	 * @param timeMax
	 */
	public GmlDrawingEvent(final GmlStroke stroke, final float timeMin, final float timeMax) {
		this.stroke = stroke;
		this.timeMin = timeMin;
		this.timeMax = timeMax;
	}
}
