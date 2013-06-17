package gml4u.events;

public class GmlSavingEvent extends GmlEvent {
	
	public String location;
	public boolean successful;
	
	/**
	 * Creates a new GmlSavingEvent using the given location
	 * @param location - String
	 * @param successful - boolean
	 */
	public GmlSavingEvent(String location, boolean successful) {
		this.location = location;
		this.successful = successful;
	}
}