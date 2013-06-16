package gml4u.utils;

import gml4u.model.Gml;
import gml4u.model.GmlPoint;
import gml4u.model.GmlStroke;

import java.util.List;

import org.apache.log4j.Logger;

import toxi.geom.AABB;
import toxi.geom.Vec3D;

public class GmlHomogenizer {
	
	private static final Logger LOGGER = Logger.getLogger(GmlHomogenizer.class.getName());
	
	private static final String CLIENT_GRAFANALYSIS = "Graffiti Analysis";
	private static final String CLIENT_FATTAG = "Fat Tag";
	private static final String CLIENT_MTAGGER_FIELD_REC = "mtaggerFieldRec";
	
	/**
	 * Fixes the coordinates issues identified in the various Gml recording apps
	 * or specific to previous Gml spec versions
	 * @param gml - Gml
	 */
	public static void autoFix(Gml gml) {
		
		
		/* Fix some Gml recorders issues
		Fat Tag - Katsu Edition Version 1.0
		-> 1 to 1
		-> Scale back with screenBounds
		*/		

		String client = gml.client.getString("name");
		
		if (CLIENT_FATTAG.equalsIgnoreCase(client)) {
			// Do nothing
			// Normalized to 1 - 1
			// Scale with screenbounds
			
			// Tag aspect ratio * screen aspect ratio
			LOGGER.debug("Client "+CLIENT_FATTAG);
			
			// Get a normalized screenBound and scale all points using this
			Vec3D screenScale = Vec3DUtils.getNormalized(gml.environment.screenBounds);			
			
			List<GmlStroke> strokes = (List<GmlStroke>) gml.getStrokes();
			for (GmlStroke stroke : strokes) {
				List<GmlPoint> points = stroke.getPoints();
				for(GmlPoint point: points) {
					point.scaleSelf(screenScale);
				}
				stroke.replacePoints(points);
			}
			gml.replaceStrokes(strokes);
		}

		/*
		Graffiti Analysis v2.0 DustTag
		-> 1 to more
		-> Already scaled
		-> Except z is fucked
		*/

		else if (CLIENT_GRAFANALYSIS.equalsIgnoreCase(client)) {
			
			// Reduce z
			// Normalize
			LOGGER.debug("Client "+CLIENT_GRAFANALYSIS);
			
			// Get max z from normalized screenBounds 
			Vec3D screenScale = Vec3DUtils.getNormalized(gml.environment.screenBounds);			
			AABB boundingBox = gml.getBoundingBox();
						
			// Remap all points' z coords accordingly
			// Might not be super accurate but good enough
			List<GmlStroke> strokes = (List<GmlStroke>) gml.getStrokes();
			for (GmlStroke stroke : strokes) {
				List<GmlPoint> points = stroke.getPoints();
				for(GmlPoint point: points) {
					point.z = MappingUtils.map(point.z, boundingBox.getMin().z, boundingBox.getMax().z, 0, screenScale.z);
					if (point.z != point.z) point.z = 0;
				}
				stroke.replacePoints(points);
			}
			gml.replaceStrokes(strokes);
		} else if ( CLIENT_MTAGGER_FIELD_REC.equalsIgnoreCase(client)) {
			
			LOGGER.debug("Client " + CLIENT_MTAGGER_FIELD_REC);
			// 8 bit processor can't normalize, too much floating point math
			// so we fix it here
			float minx = 10000, miny = 10000, maxx = -10000, maxy = -10000;

			List<GmlStroke> strokes = (List<GmlStroke>) gml.getStrokes();
			for (GmlStroke stroke : strokes) {
				List<GmlPoint> points = stroke.getPoints();
				for(GmlPoint point: points) {

					if(point.x > maxx) maxx = point.x;
					if(point.y > maxy) maxy = point.y;
					if(point.x < minx) minx = point.x;
					if(point.y < miny) miny = point.y;

				}
			}

			float yrange = maxy - miny;
			float xrange = maxx - minx;
			
			for (GmlStroke stroke : strokes) {
				List<GmlPoint> points = stroke.getPoints();
				for(GmlPoint point: points) {

					point.x -= minx;
					point.x  /= xrange;
					point.y -= miny;
					point.y /= yrange;

				}
				stroke.replacePoints(points);
			}



		}
	}
}
