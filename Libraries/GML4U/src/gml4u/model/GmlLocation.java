package gml4u.model;

public class GmlLocation {

	private long lat;
	private long lon;
	private long alt;

	/**
	 * Creates a new location with default values
	 */
	public GmlLocation() {
		set(0, 0, 0);
	}
	
	/**
	 * Creates a new location with the given lat/lon and alt set to 0
	 * @param lat
	 * @param lon
	 */
	public GmlLocation(long lat, long lon) {
		set(lat, lon, 0);
	}

	/**
	 * Creates a new location with the given lat/lon/alt
	 * @param lat
	 * @param lon
	 * @param alt
	 */
	public GmlLocation(long lat, long lon, long alt) {
		set(lat, lon, alt);
	}
	
	/**
	 * Set alt/lon/alt
	 * @param lat - long
	 * @param lon - long
	 * @param alt - long
	 */
	public void set(long lat, long lon, long alt) {
		this.lat = lat;
		this.lon = lon;
		this.alt = alt;
	}
	
	/**
	 * Gets the latitude
	 * @return long
	 */
	public long getLat() {
		return lat;
	}

	/**
	 * Gets the longitude
	 * @return long
	 */
	public long getLon() {
		return lon;
	}

	/**
	 * Gets the altitude
	 * @return long
	 */
	public long getAlt() {
		return alt;
	}

	/**
	 * Sets the latitude
	 * @param lat - long
	 */
	public void setLat(long lat) {
		this.lat = lat;
	}

	/**
	 * Sets the longitude
	 * @param lon - long
	 */
	public void setLon(long lon) {
		this.lon = lon;
	}

	/**
	 * Sets the altitude
	 * @param alt - long
	 */
	public void setAlt(long alt) {
		this.alt = alt;
	}
}
