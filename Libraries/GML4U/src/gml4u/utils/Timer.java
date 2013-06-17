package gml4u.utils;

public class Timer {

	private float time = 0;
	private boolean started = false;
	private boolean paused = false;
	private float step = .04f;
	
	/**
	 * Timer constructor
	 */
	public Timer() {
	}
	
	/**
	 * Returns the time
	 * @return float
	 */
	public float getTime() {
		return time;
	}
	
	/**
	 * Sets the time
	 * @param time
	 */
	public void setTime(float time) {
		this.time = time;
	}
	
	/**
	 * Resets the time
	 */
	public void reset() {
		time = 0;
	}
	
	/**
	 * Starts the timer and sets time to 0;
	 */
	public void start() {
		started = true;
		paused = false;
		reset();
	}

	/**
	 * Checks if the timer is started or not
	 * @return boolean
	 */
	public boolean started() {
		return started;
	}

	/**
	 * Checks if the timer is paused or not
	 * @return boolean
	 */
	public boolean paused() {
		return paused;
	}
	
	/**
	 * Pauses the timer
	 * @param b - boolean
	 */
	public void pause(boolean b) {
		paused = b;
	}
	
	/**
	 * Stops the timer and sets the time to 0
	 */
	public void stop() {
		started = false;
		paused = true;
		reset();
	}
	
	/**
	 * Returns the interval used by tick()
	 * @param step
	 */
	public float getStep() {
		return step;
	}
	
	/**
	 * Sets the interval used by tick() when used without argument
	 * @param step
	 */
	public void setStep(float step) {
		this.step = step;
	}
	
	/**
	 * Inverts the direction of timer
	 */
	public void invert() {
		step *= -1;
	}
	
	
	/**
	 * Adds the defined step interval to the timer
	 */
	public void tick() {
		tick(step);
	}
	
	/**
	 * Adds the given value to timer
	 * @param step
	 */
	public void tick(float step) {
		if (started & !paused) {
			time += step;
		}
	}
}
