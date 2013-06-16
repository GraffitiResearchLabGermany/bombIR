package gml4u.utils;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import org.apache.log4j.Logger;

public class FileUtils {

	private static final Logger LOGGER = Logger.getLogger(FileUtils.class.getName());

	public static final String GML_FILE_REGEX = "^.*\\.gml$";
	public static final String XML_FILE_REGEX = "^.*\\.xml$";
	public static final String GML_XML_FILE_REGEX = "^.*\\.(x|g)ml$";
	
	/**
	 * Lists and filters files inside the given folder using a regular expression
	 * If the regex is badly formatted, empty or null, then the result will not be filtered
	 * @param folder
	 * @param regex
	 * @return List<String>
	 */
	public static List<String> scanFolder(String folder, String regex) {
		if (null == regex || regex.length() == 0) {
			LOGGER.warn("Regex is empty of null: will search for \"*.gml\" files");
			regex = GML_FILE_REGEX;
		}
		else {
			try {
	            Pattern.compile(regex);
	        } catch (PatternSyntaxException exception) {
				LOGGER.warn("Regex is invalid, not filter will be used "+exception.getMessage());
				regex = ".*";	        	
	        }
		}
		File dir = new File(folder);
		String[] fileList = dir.list();
		List<String> filteredList = new ArrayList<String>(); 
		if (null != fileList) {
			for (int i=0; i<fileList.length; i++) {
				if (fileList[i].matches(regex)) {
					filteredList.add(folder+"/"+fileList[i]);
				}
			}
		}
		return filteredList;
	}
	
	/**
	 * Lists files (with a .gml extension) inside the given folder
	 * @param folder
	 * @return List<String>
	 */
	public static List<String> scanFolder(String folder) {
		return scanFolder(folder, GML_FILE_REGEX);
	}
	
	/**
	 * Generates a random name for GML4U files
	 * @return
	 */
	public static String generateRandomName() {
		return "GML4U_"+UUID.randomUUID().toString()+".gml";
	}
	
	/**
	 * Ensures that the give folder exists by creating it if needed
	 * @param folder
	 */
	public static void ensureFolderExists(String folder) {
		File file = new File(folder);
		boolean success = file.mkdirs();
		if (!success) {
		    LOGGER.debug("Wrong folder name or folder already exists: "+folder);
		}
		else {
			LOGGER.debug("Created folder: "+folder);
		}
	}
	
	/**
	 * Removes a filename from a full path and returns the folder path
	 * Returns null if the path is incorrect
	 * @param filePath
	 * @return
	 */
	public static String getFolder(String filePath) {
		String regex = "^(.*)/([^/]*)$";
		if (filePath.matches(regex)) {
		  String folder = filePath.replaceAll(regex, "$1");
		  return folder;
		}
		return null;
	}
}
