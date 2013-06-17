package gml4u.drawing;

import gml4u.events.GmlDrawingEndEvent;
import gml4u.events.GmlDrawingEvent;
import gml4u.events.GmlDrawingStartEvent;
import gml4u.events.GmlEventHandler;
import gml4u.events.GmlStrokeEndEvent;
import gml4u.events.GmlStrokeStartEvent;
import gml4u.model.Gml;
import gml4u.model.GmlPoint;
import gml4u.model.GmlStroke;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;


public class GmlDrawingManager {

	private static final Logger LOGGER = Logger.getLogger(GmlDrawingManager.class.getName());

	private Gml gml;
	private GmlEventHandler eventHandler;
	private boolean started = false;	
	private ArrayList<String> stagedStrokesIds;

	/**
	 * Creates a new GmlDrawingManager
	 */
	public GmlDrawingManager() {
		eventHandler = new GmlEventHandler();
		stagedStrokesIds = new ArrayList<String>();
	}
	
	/**
	 * Creates a new GmlDrawingManager and register for callback in the meantime
	 */
	public GmlDrawingManager(Object o) {
		this();
		register(o);
	}

	/**
	 * Creates a new GmlDrawingManager with the given Gml
	 * @param gml - Gml
	 */
	public GmlDrawingManager(final Gml gml) {
		this();		
		setGml(gml);
	}

	/**
	 * Sets the Gml to be used by the drawing manager
	 * Resets the drawing manager in the meantime
	 * @param gml - Gml
	 */
	public void setGml(final Gml gml) {
		this.gml = gml;
		reset();
	}
	
	/**
	 * Registers a listener to receive GmlEvents
	 * Note: the Object passed must implement a public gmlEvent(GmlEvent event) method
	 * @param listener - Object
	 */
	public void register(final Object listener) {
		eventHandler.addListener(listener);
	}
	
	/**
	 * Unregisters a listener
	 * @param listener - Object 
	 */
	public void unregister(final Object listener) {
		eventHandler.removeListener(listener);
	}

	/**
	 * Resets the drawing manager
	 * Clears the staged strokes list and sets drawing's started status to false
	 */
	public void reset() {
		started = false;
		stagedStrokesIds.clear();
	}
	
	/**
	 * Pulses the drawing manager which will send the matching GmlEvents to its
	 * listeners (start, drawing, stroke start, stroke end, stop) in return.
	 * @param time - float
	 */
	public void pulse(float time) {
		pulse(Float.MIN_VALUE, time);
	}
	
	/**
	 * Pulses the drawing manager which will send the matching GmlEvents to its
	 * listeners (start, drawing, stroke start, stroke end, stop) in return.
	 * @param timeMin - float beginning of interval
	 * @param timeMax - float end of interval
	 */
	public void pulse(float timeMin, float timeMax) {

		if (timeMin > timeMax) {
			LOGGER.warn("Interval error, doing noting. Reason: start time must be lower than end time");
		}
		
		else if (null != gml) {
			
			// Checks if drawing started
			if (!started) {
				LOGGER.debug("Drawing start");
				// Fire new GmlDrawingStartEvent
				GmlDrawingStartEvent event = new GmlDrawingStartEvent(gml);
				eventHandler.fireNewEvent(event);
				started = true;
			}
			
			// TODO scan first and then send event afterward
			for (GmlStroke stroke : gml.getStrokes()) {
				
				// Checks if stroke is new
				if (!stagedStrokesIds.contains(stroke.getID())) {
					LOGGER.debug("Stroke start");
					// fire new GmlStrokeStartEvent
					GmlStrokeStartEvent event = new GmlStrokeStartEvent(stroke);
					eventHandler.fireNewEvent(event);
					// set as staged stroke
					stagedStrokesIds.add(stroke.getID());
				}
				
				// Get the list of points for every stroke
				List<GmlPoint> points = stroke.getPoints(timeMin, timeMax);
				// Checks if it contains points
				if (points.size() > 0) {
					// Fire new GmlDrawingEvent
					GmlDrawingEvent event = new GmlDrawingEvent(stroke, timeMin, timeMax);
					eventHandler.fireNewEvent(event);
				}
				
				// Checks if stroke still has points to draw
				if (stroke.nbPoints() == points.size()) {
					LOGGER.debug("Stroke end");
					// Fire new GmlStrokeEndEvent
					GmlStrokeEndEvent event = new GmlStrokeEndEvent(stroke);
					eventHandler.fireNewEvent(event);
				}
			}			
			
			// Checks if drawing ended
			if (timeMax > gml.getDuration()) {
				LOGGER.debug("Drawing end");
				// Fire new GmlDrawingEndEvent
				GmlDrawingEndEvent event = new GmlDrawingEndEvent();
				eventHandler.fireNewEvent(event);
			}
		}
	}
}