package gml4u.utils;


import gml4u.events.GmlEvent;
import gml4u.events.GmlParsingEvent;
import gml4u.model.Gml;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

public class GmlParser extends Thread {

	private static final Logger LOGGER = Logger.getLogger(GmlParser.class.getName());
	
	private boolean running;           // Is the thread running?  Yes or no?
	private int wait;                  // How many milliseconds should we wait in between executions?
	private String threadId;           // Thread name
	private boolean normalize;
	private List<String> fileList = new ArrayList<String>();
	private Object parent;
	private Method callback;

	/**
	 * Creates a new GmlMultiParser thread
	 * The parent object must implement a <i>public void gmlEvent(GmlEvent event)</i> method.
	 * @param wait - int (waiting time in ms)
	 * @param id - String (thread id)
	 * @param parent - Object
	 */
	public GmlParser (int wait, String id, Object parent){
		try {
			// Looking for a method called "gmlEvent", with one argument of GmlEvent type
			callback = parent.getClass().getMethod("gmlEvent", new Class[] { GmlEvent.class });
		}
		catch (Exception e) {
			LOGGER.warn(parent.getClass()+" shall implement a \"public void gmlEvent(GmlEvent event)\" method to be able to receive GmlEvent");
		}

		this.parent = parent;
		this.wait = wait;
		this.running = false;
		this.threadId = id;
		
		start();
	}

	/**
	 * Starts the thread
	 */
	public void start () {
		LOGGER.debug("Starting thread");
		if (!running) {
			running = true;
			super.start();
		}
	}

	/**
	 * Run method triggered by start()
	 */
	public void run () {
		while (running){
			try {
				if (fileList.size() > 0) {
					LOGGER.debug("Start parsing: "+fileList.size()+ "files");
					
					for (String fileName : fileList) {
						Gml gml = GmlParsingHelper.getGml(fileName, normalize);
						if (null != gml && null !=callback) {
							try {
								// Call the method with this object as the argument!
								LOGGER.debug("Invoking callback");
								callback.invoke(parent, new GmlParsingEvent(gml) );
							}
							catch (Exception e) {
								//LOGGER.debug("Couldn't invoke the callback method for some reason. "+e.getMessage());
							}
						}
					}
				}
				fileList.clear();

				sleep((long)(wait));	
			}
			// TODO Lock and loop issue exception when NullPointerExceptions in GmlMultiParsingHelper
			catch (Exception e) {
				//LOGGER.warn(e.getMessage());
			}
		}
		LOGGER.debug(threadId + " thread is done!");  // The thread is done when we get to the end of run()
		quit();
	}

	/**
	 * Parses GML files matching the regex and found in the given folder and normalizes them if explicitly asked.<br/>
	 * Must be a local file.<br/>
	 * @param folder - String
	 * @param regex - String
	 * @param normalize - boolean
	 */
	public void parseFolder(final String folder, String regex, boolean normalize) {
		LOGGER.debug("Scanning "+folder);
		List<String> files = FileUtils.scanFolder(folder, regex);
		this.fileList.addAll(files);
		this.normalize = normalize;
	}

	/**
	 * Parses GML files (with .gml extension) found in the given folder and normalizes them if explicitly asked.<br/>
	 * Must be a local file <br/>
	 * @param folder - String
	 * @param normalize - boolean
	 */
	public void parseFolder(final String folder, boolean normalize) {
		parseFolder(folder, FileUtils.GML_FILE_REGEX, normalize);
	}
	
	/**
	 * Parses and normalizes GML files matching the given regex and found in the given folder.<br/>
	 * Must be a local file <br/>
	 * @param folder - String
	 * @param regex - String
	 */
	public void parseFolder(final String folder, String regex) {
		parseFolder(folder, regex, true);
	}
	
	/**
	 * Parses a list of GML file using their given location and normalizes them.<br/>
	 * Must be a local file <br/>
	 * @param folder - String
	 * @param normalize - boolean
	 */
	public void parseFolder(final String folder) {
		parseFolder(folder, FileUtils.GML_FILE_REGEX, true);
	}

	/**
	 * Parses a list of GML files using their given location and normalizes them if explicitly asked.<br/>
	 * Can be local files or http resources as well.<br/>
	 * Note that you might need a local proxy to access extenal http resources when running inside an unsigned Applet 
	 * @param fileList - String
	 * @param normalize - boolean
	 */
	public void parseFiles(final List<String> fileList, boolean normalize) {
		LOGGER.debug(fileList + " to be parsed");
		this.fileList.addAll(fileList);
		this.normalize = normalize;
	}
	
	/**
	 * Parses a list of GML files using their given location and normalizes them.<br/>
	 * Can be local files or http resources as well.<br/>
	 * Note that you might need a local proxy to access extenal http resources when running inside an unsigned Applet 
	 * @param fileList - String
	 */
	public void parseFiles(final List<String> fileList) {
		parseFiles(fileList, true);
	}
	
	/**
	 * Parses a GML file using its given location and normalizes it if explicitly asked.<br/>
	 * Can be a local files or a http resources as well.<br/>
	 * Note that you might need a local proxy to access extenal http resources when running inside an unsigned Applet 
	 * @param file - String
	 * @param normalize - boolean
	 */
	public void parse(final String file, boolean normalize) {
		LOGGER.debug(file + " to be parsed");
		this.fileList.add(file);
		this.normalize = normalize;
	}
	
	/**
	 * Parses a GML file using its given location and normalizes it.<br/>
	 * Can be local file or a http resources as well.<br/>
	 * Note that you might need a local proxy to access extenal http resources when running inside an unsigned Applet 
	 * @param fileList - String
	 */
	public void parse(final String file) {
		parse(file, true);
	}

	/**
	 * Quits the thread
	 */
	public void quit() {
		LOGGER.debug(threadId + " quitting.");
		running = false;
		interrupt(); // in case the thread is waiting. . .
	}
}