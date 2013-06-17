package gml4u.utils;

import org.apache.log4j.Logger;

public class CallbackUtils {

	private static final Logger LOGGER = Logger.getLogger(CallbackUtils.class.getName());

	/**
	 * Checks if the provided Object implements the given method and argument
	 * @param object - Object
	 * @param methodName - String
	 * @param classe - Class
	 * @return boolean
	 */
	public static boolean hasRequiredCallback(Object object, String methodName, Class<?> classe) {
		
		try {
			object.getClass().getMethod(methodName, classe);
		} catch (SecurityException e) {
			LOGGER.warn("Cannot access methods of "+object.getClass().getName());
			return false;
		} catch (NoSuchMethodException e) {
			LOGGER.warn(object.getClass().getName()+" must implement this method: public void "+methodName+"("+classe.getCanonicalName()+")");
			return false;
		}
		return true;
	}
}
