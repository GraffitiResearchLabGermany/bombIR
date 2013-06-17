package gml4u.events;

import gml4u.utils.CallbackUtils;

import java.lang.reflect.InvocationTargetException;
import java.util.HashSet;
import java.util.Set;

import org.apache.log4j.Logger;

public class GmlEventHandler {

	private static final Logger LOGGER = Logger.getLogger(GmlEventHandler.class.getName());

	private Set<Object> listeners = new HashSet<Object>();
	private final String callbackMethod = "gmlEvent";	
	//@SuppressWarnings("unchecked")
	private final Class<?> callbackParameterClass = GmlEvent.class; 

	/**
	 * Creates a new GmlEventHandler
	 */
	public GmlEventHandler() {
	}
	
	/**
	 * Adds a new listener
	 * @param listener - Object implementing a public gmlEvent(GmlEvent) method
	 */
	public void addListener(Object listener) {

		// Check callback methods
		if (CallbackUtils.hasRequiredCallback(listener, "gmlEvent", GmlEvent.class)) {
			listeners.add(listener);
		}
	}

	/**
	 * Removes the given listener
	 * @param listener - Object implementing a gmlEvent(GmlEvent) method
	 */
	public void removeListener(Object listener) {
		if (listeners.contains(listener)) {
			listeners.remove(listener);
		}
		else {
			LOGGER.info("Listener dosen't exist, doing nothing");
		}
	}

	/**
	 * Fires a new GmlEvent to every registered listener
	 * @param event - GmlEvent
	 */
	public void fireNewEvent(GmlEvent event) {
		for (Object listener : listeners) {
			try {
				listener.getClass().getMethod(callbackMethod, callbackParameterClass).invoke(listener, event);
			} catch (IllegalArgumentException e) {
				LOGGER.error(e.getMessage());
			} catch (SecurityException e) {
				LOGGER.error(e.getMessage());
			} catch (IllegalAccessException e) {
				LOGGER.error(e.getMessage());
			} catch (InvocationTargetException e) {
				LOGGER.error(e.getMessage());
			} catch (NoSuchMethodException e) {
				LOGGER.error(e.getMessage());
			}
		}
	}
}