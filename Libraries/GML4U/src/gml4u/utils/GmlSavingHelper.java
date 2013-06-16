package gml4u.utils;
import gml4u.model.Gml;
import gml4u.model.GmlBrush;
import gml4u.model.GmlClient;
import gml4u.model.GmlEnvironment;
import gml4u.model.GmlInfo;
import gml4u.model.GmlLocation;
import gml4u.model.GmlPoint;
import gml4u.model.GmlStroke;

import java.awt.Color;
import java.io.IOException;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import toxi.geom.Vec3D;


public class GmlSavingHelper {

	private static final Logger LOGGER = Logger.getLogger(GmlSavingHelper.class.getName());

	/**
	public static void uploadTo000000Book(final Gml gml) {
		try {
			// Create document from Gml and get it as a String
			Document document = createDocument(gml);
			String gmlString = XmlUtils.getString(document);
			
			System.out.println(gmlString);

		    // Construct data
		    String data = URLEncoder.encode("application", "UTF-8") + "=" + URLEncoder.encode(GmlConstants.GML4U_CLIENT_NAME, "UTF-8");
		    data += "&" + URLEncoder.encode("data", "UTF-8") + "=" + URLEncoder.encode(gmlString, "UTF-8");

		    // TODO 
		    
		    // Send data
		    //URL url = new URL("http://000000book.com/data");
		    URL url = new URL("http://000000book.com/validate");
		    
		    URLConnection conn = url.openConnection();
		    conn.setDoOutput(true);
		    OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
		    wr.write(data);
		    wr.flush();

		    // Get the response
		    BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		    String line;
		    while ((line = rd.readLine()) != null) {
		        LOGGER.debug(line);
		    }
		    wr.close();
		    rd.close();
		} catch (Exception e) {
			
		}
		
	}
	*/

	/**
	 * Saves a Gml file to the given location (path + filename)
	 * @param gml - Gml
	 * @param location - String
	 * @return boolean
	 */
	public static boolean save(final Gml gml, final String location) {

		// TODO choose which version to save into and create a factory
		
		LOGGER.debug("Start saving GML file to "+location);
		

		try {
			// Make sure the folder exists
			String folder = FileUtils.getFolder(location);
			FileUtils.ensureFolderExists(folder);
			// Save the file
			Document document = createDocument(gml);
			XmlUtils.saveDocument(document, location);
			return true;
		}
		catch (IOException e) {
			LOGGER.error("Saving failed. Reason: "+ e.getMessage());
		}
		catch (ParserConfigurationException e) {
			LOGGER.error("Saving failed. Reason: parsing issue, "+ e.getMessage());
		}
		return false;
	}

	/**
	 * Gets Gml as a Xml document
	 * @param gml - Gml
	 * @return Document
	 * @throws ParserConfigurationException
	 */
	private static Document createDocument(final Gml gml) throws ParserConfigurationException {
		LOGGER.debug("Start building Xml from Gml");

		Document document = XmlUtils.createDocument();

		// GML
		Element root = document.createElement("gml");
		root.setAttribute("spec", "1.0");
		document.appendChild(root);

		// No plans to support/implement multiple tags elements

		// TAG
		Element tag = document.createElement("tag");
		root.appendChild(tag);


		// HEADER
		Element header = document.createElement("header");
		tag.appendChild(header);

		// CLIENT
		Element client = createClientElement(document, gml.client);
		header.appendChild(client);

		// ENVIRONMENT
		Element environment = createEnvironmentElement(document, gml.environment);
		header.appendChild(environment);

		// DRAWING
		Element drawing = document.createElement("drawing");
		tag.appendChild(drawing);

		// STROKES
		for (GmlStroke stroke : gml.getStrokes()) {

			if (stroke.nbPoints() > 0) {
				Element strokeElement = createStrokeElement(document, stroke);
				strokeElement.setAttribute("layer", ""+stroke.getLayer());
				drawing.appendChild(strokeElement);
			}
		}

		LOGGER.debug("Finished building document");
		return document; 
	}

	/**
	 * Creates a client element
	 * @param document - Document 
	 * @param client - GmlClient
	 * @return Element
	 */
	private static Element createClientElement(Document document, GmlClient client) {
		Element element = document.createElement("client");

		// Create child elements
		createAnyElement(document, element, client.getParameters());
		
		return element;
	}

	/**
	 * Creates an environement element
	 * @param document - Document
	 * @param environment - GmlEnvironment
	 * @return Element
	 */
	private static Element createEnvironmentElement(Document document, GmlEnvironment environment) {
		Element element = document.createElement("environment");		

		// TODO iterate through all elements and create specific ones
		
		
		// SCREENBOUNDS
		if (environment.screenBounds != null) {
			Element envScreenBounds = createVec3DElement(document, "screenBounds", environment.screenBounds);
			element.appendChild(envScreenBounds);
		}

		// UP (Mandatory)
		Element envUp = createVec3DElement(document, "up", environment.up);
		element.appendChild(envUp);

		// SCREENSCALE (Mandatory)
		// Get largest
		float scale = Vec3DUtils.getLongestAxisSize(environment.screenBounds);
		Element envScreenScale = document.createElement("screenScale");
		envScreenScale.appendChild(document.createTextNode("" + (int) scale));
		element.appendChild(envScreenScale);

		// OFFSET
		if (environment.offset !=  null) {
			Element envOffset = createVec3DElement(document, "offset", environment.offset);
			element.appendChild(envOffset);
		}

		// ROTATION
		if (environment.rotation != null) {
			Element envRotation = createVec3DElement(document, "rotation", environment.rotation);
			element.appendChild(envRotation);
		}

		// ORIGIN
		if (environment.origin != null) {
			Element envOrigin = createVec3DElement(document, "origin", environment.origin);
			element.appendChild(envOrigin);
		}

		// REALSCALE

		if (environment.realScale != null) {
			Element envRealscale = createVec3DElement(document, "realscale", environment.realScale);
			Element envRealScaleUnit= document.createElement("unit");
			envRealScaleUnit.appendChild(document.createTextNode(environment.realScaleUnit));
			envRealscale.appendChild(envRealScaleUnit);
			element.appendChild(envRealscale);
		}

		return element;
	}

	/**
	 * Creates a stroke element
	 * @param document - Document
	 * @param stroke - GmlStroke
	 * @return Element
	 */
	private static Element createStrokeElement(Document document, GmlStroke stroke) {
		Element element = document.createElement("stroke");		

		// ISDRAWING (only set if false, true by default)
		if (!stroke.getIsDrawing()) {
			element.setAttribute("isDrawing", "false");
		}

		// LAYER
		element.setAttribute("layer", ""+stroke.getLayer());

		// BRUSH
		if (null != stroke.getBrush()) {
			Element brush = createBrushElement(document, stroke.getBrush());
			element.appendChild(brush);
		}

		// INFO
		if (null != stroke.getInfo() && stroke.getInfo().getParameters().size() > 0) {
			Element info = createInfoElement(document, stroke.getInfo());
			element.appendChild(info);
		}

		// PT
		for(GmlPoint point: stroke.getPoints()) {
			element.appendChild(createPointElement(document, point));
		}

		return element;
	}

	/**
	 * Creates a brush element
	 * @param document - Document
	 * @param brush - GmlBrush
	 * @return Element
	 */
	private static Element createBrushElement(Document document, GmlBrush brush) {

		Element element = document.createElement("brush");
				
		// Create child elements
		createAnyElement(document, element, brush.getParameters());
		
		return element;
	}
	
	/**
	 * Creates an info element
	 * @param document - Document
	 * @param info - GmlInfo
	 * @return
	 */
	private static Element createInfoElement(Document document, GmlInfo info) {
		Element element = document.createElement("info");

		// Create child elements
		createAnyElement(document, element, info.getParameters());

		return element;
	}

	/**
	 * Creates a Vec3D element
	 * @param document - Document
	 * @param name - String
	 * @param v - Vec3D
	 * @return Element
	 */
	private static Element createVec3DElement(Document document, String name, Vec3D v) {
		return createVec3DElement(document, name, v, false);
	}
	
	/**
	 * Creates a Vec3D element or Vec2D element if z = 0 and autoVec2D is true
	 * @param document - Document
	 * @param name - String
	 * @param v - Vec3D
	 * @param autoVec2D - boolean
	 * @return Element
	 */
	private static Element createVec3DElement(Document document, String name, Vec3D v, boolean autoVec2D) {
		Element element = document.createElement(name);

		Element x = document.createElement("x");
		x.appendChild(document.createTextNode(""+v.x));
		element.appendChild(x);
		Element y = document.createElement("y");
		y.appendChild(document.createTextNode(""+v.y));
		element.appendChild(y);
		
		//if (0 != v.z ||  !autoVec2D) { // Optional
			Element z = document.createElement("z");
			z.appendChild(document.createTextNode(""+v.z));
			element.appendChild(z);
		//}
		return element;
	}
	
	/**
	 * Creates a Location element
	 * @param document - Document
	 * @param name - String
	 * @param loc - GmlLocation
	 * @return Element
	 */
	private static Element createLocationElement(Document document, String name, GmlLocation loc) {
		Element element = document.createElement(name);

		Element lat = document.createElement("lat");
		lat.appendChild(document.createTextNode(""+loc.getLat()));
		element.appendChild(lat);
		
		Element lon = document.createElement("lon");
		lon.appendChild(document.createTextNode(""+loc.getLon()));
		element.appendChild(lon);
		
		// Optional
		if (0 != loc.getAlt()) {
			Element alt = document.createElement("alt");
			alt.appendChild(document.createTextNode(""+loc.getAlt()));
			element.appendChild(alt);
		}
		return element;
	}
	
	/**
	 * Creates a Point element and children
	 * @param document
	 * @param point
	 * @return
	 */
	private static Element createPointElement(Document document, GmlPoint point) {

		// Coords
		Element element = createVec3DElement(document, "pt", point, true);

		// Time
		if (0 != point.time) { // Optional
			Element t = document.createElement("t");
			t.appendChild(document.createTextNode(""+point.time));
			element.appendChild(t);
		}
		
		// Rotation
		if (!point.rotation.isZeroVector()) { // Optional
			Element rot = createVec3DElement(document, "rot", point.rotation);
			element.appendChild(rot);
		}

		// Direction
		if (!point.direction.isZeroVector()) { // Optional
			Element dir = createVec3DElement(document, "dir", point.direction);
			element.appendChild(dir);
		}

		// Pressure
		if (0 != point.preasure) { // Optional
			Element pres = document.createElement("pres");
			pres.appendChild(document.createTextNode(""+point.preasure));
			element.appendChild(pres);
		}
		return element;
	}
	
	/**
	 * Creates a Color element
	 * @param document - Document
	 * @param name - String
	 * @param c - Color
	 * @return Element
	 */
	private static Element createColorElement(Document document, String name, Color c) {
		Element element = document.createElement(name);

		Element r = document.createElement("r");
		r.appendChild(document.createTextNode(""+c.getRed()));
		element.appendChild(r);
		
		Element g = document.createElement("g");
		g.appendChild(document.createTextNode(""+c.getGreen()));
		element.appendChild(g);
		
		Element b = document.createElement("b");
		b.appendChild(document.createTextNode(""+c.getBlue()));
		element.appendChild(b);
		
		Element a = document.createElement("a");
		a.appendChild(document.createTextNode(""+c.getAlpha()));
		element.appendChild(a);

		return element;
	}
	
	/**
	 * Adds child elements from a Map based on their type
	 * @param document - Document
	 * @param element - Element
	 * @param map - Map<String, Object>
	 */
	private static void createAnyElement(Document document, Element element, Map<String, Object> map) {
		
		for (String key : map.keySet()) {
			Object o = map.get(key);
			Element child;

			if (o instanceof Vec3D) {
				child = createVec3DElement(document, key, (Vec3D) o); 
			}
			else if (o instanceof Float) {
				child = document.createElement(key);
				child.appendChild(document.createTextNode(""+(Float) o));
			}
			else if (o instanceof Color) {
				child = createColorElement(document, key, (Color) o); 				
			}
			else if (o instanceof GmlLocation) {
				child = createLocationElement(document, key, (GmlLocation) o); 				
			}
			else { // Get it as a String
				child = document.createElement(key);
				child.appendChild(document.createTextNode((String) o));				
			}
			element.appendChild(child);				
		}
	}
}