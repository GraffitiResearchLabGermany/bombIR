/*--------------------------------------------------------------------- 

  OBAMA GML PLAYA 

  by Golan Levin & Jerome Saint-Clair 
  for GraffitiMarkupLanguage + F.A.T. Lab.
  
  http://www.flong.com
  http://www.saint-clair.net
  http://www.graffitimarkuplanguage.com
  http://www.fffff.at

  White House photo by Pete Souza (Government Work).

--------------------------------------------------------------------- */

// Currently broken due to major changes in version 0.1.0
// Will try to fix that soon

/*
import org.apache.log4j.PropertyConfigurator;

import gml4u.utils.*;
import gml4u.events.*;
import gml4u.model.exceptions.*;
import gml4u.model.*;

import toxi.geom.Vec2D;
import toxi.geom.Vec3D;


PFont font;

String proxyLocation;

String latestGmlUrl = "?api=latest";
String randomGmlUrl = "?api=random";
String nextFile;

// Set this to true if you're offline
boolean local = false;

boolean autoMode = true;

GmlParser gp;
GmlDrawingManager gdm;
Gml currentGml;
Gml nextGml;

String currentTagID = "";

PImage helpImg, loadingImg;
boolean showClientInfo = false;
boolean showHelp = true;
String  tagID = "";

ObamaDrawer drawer;
PImage wallImg, obamaFrontImage, obamaFrontMask, obamaShadow, obamaArmImage, obamaArmShadowImage, obamaArmMaskNoShadow, obamaArmMaskShadow;


void setup() {
  size(1024, 683);
  PropertyConfigurator.configure(sketchPath+"/log4j.properties");

  frameRate(24);
  cursor(CROSS);
  smooth();
  font = createFont("Arial", 20);

    // Get local proxy url from proxyURL.txt
    String[] proxyFile = loadStrings("./proxyURL.txt");
    // The url should be in the first line of the file
    proxyLocation = proxyFile[0];

  if (local) { // Only play those two local files
    randomGmlUrl = sketchPath+"/data/19518.gml.xml";
    latestGmlUrl = sketchPath+"/data/148.gml.xml";			
    nextFile = latestGmlUrl;
  }
  else { // Play Hello world first
    nextFile = "?tagid=148";
  }

  helpImg 		= loadImage("obama-text.png");
  loadingImg 		= loadImage("obama-loading.png");

  wallImg 		= loadImage("wall.jpg");
  obamaShadow 		= loadImage("obama_background.jpg");
  obamaFrontImage     	= loadImage("obama_front_image.jpg"); 
  obamaFrontMask      	= loadImage("obama_front_mask.png");
  obamaArmImage       	= loadImage("obama_arm_image.jpg"); 
  obamaArmShadowImage 	= loadImage("obama_arm_image.jpg"); 
  obamaArmMaskNoShadow	= loadImage("obama_arm_mask_no_shadow.png"); 
  obamaArmMaskShadow	= loadImage("obama_arm_mask_shadow.jpg"); 

  obamaFrontImage.mask(obamaFrontMask);
  obamaArmImage.mask(obamaArmMaskNoShadow);
  obamaArmShadowImage.mask(obamaArmMaskShadow);


  gdm = new GmlDrawingManager();
  gp = new GmlParser(500, "1", this);
  gp.start();

  drawer = new ObamaDrawer(width, height, 0, .6f, obamaShadow, obamaFrontImage, obamaArmImage, obamaArmShadowImage);
  gdm.register(drawer, 0);

  parseGml(nextFile);
  nextFile = "";
}

void draw() {
  image(wallImg, 0, 0);

  if (drawer.finished) {
    drawer.finished = false;
    loadNext();
    if (autoMode) {
      nextFile = randomGmlUrl;
    }
  }
  else {
    if (drawer.transition) {
      // Freeze
      frameCount = frameCount-1;
    }
    else {
      // Pulse
      gdm.pulse(frameCount/frameRate);
    }
    drawer.draw(g);
  }

  showCommands();

  if (showHelp) {
    showHelp();
  }

  if (showClientInfo) {
    showClientInfo(27, 60);
  }

  if (!(nextFile.equals(""))) {
    parseGml(nextFile);
    nextFile = "";
  }
}


private String getTagID(String id) {
  id = id.replaceAll("http://000000book.com/data/", "");
  id = id.replaceAll("(\\.gml|\\.xml)", "");
  return id;
}

public void mouseMoved() {
  cursor(CROSS);
  if (showHelp) {
    if (mouseX > 48 && mouseX<126 && mouseY >489 && mouseY <504) {
      cursor(HAND);
    }
    else if  (mouseX > 141 && mouseX<265 && mouseY >489 && mouseY <504) {
      cursor(HAND);
    }
    else if (mouseX > 89 && mouseX<270 && mouseY >506 && mouseY <529) {
      cursor(HAND);
    }
    else if  (mouseX > 187 && mouseX<305 && mouseY >625 && mouseY <646) {
      cursor(HAND);
    }
  }
}


public void mouseReleased() {
  if(showHelp) {
    if (mouseX > 48 && mouseX<126 && mouseY >489 && mouseY <504) {
      link("http://www.flong.com/","_new");
    }
    else if  (mouseX > 141 && mouseX<265 && mouseY >489 && mouseY <504) {
      link("http://saint-clair.net/","_new");
    }
    else if (mouseX > 89 && mouseX<270 && mouseY >506 && mouseY <529) {
      link("http://graffitimarkuplanguage.com/","_new");
    }
    else if  (mouseX > 187 && mouseX<305 && mouseY >625 && mouseY <646) {
      link("http://000000book.com/","_new");
    }
  }
}

private void showHelp() {
  pushMatrix();
  translate(0, height-helpImg.height);
  image(helpImg, 0, 0);
  popMatrix();
}


public void gmlEvent(GmlEvent event) {
  if (event instanceof GmlParsingEvent && null != ((GmlParsingEvent) event).gml) {
    nextGml = ((GmlParsingEvent) event).gml;
    GmlUtils.timeBox(nextGml, 15.f, true);
    GmlUtils.normalize(nextGml);
    if (!autoMode || (autoMode && null == currentGml)) {
      loadNext();
    }
  }
}

private void showCommands() {
  int x = 0;
  int y = 0;

  // TagID
  pushStyle();
  noFill();
  stroke(255);
  strokeWeight(1);
  x = width-75;
  y = 30;

  fill(255);
  textAlign(LEFT, CENTER);
  text(currentTagID, x, y);
  text(tagID, x, y+20);			
  popStyle();


  // Loading status
  pushStyle();
  x = 30;
  y = 35;

  textAlign(LEFT, CENTER);
  if (!gp.isAvailable()) {
    image(loadingImg, 0, 20);
  }
  popStyle();
}

private void showClientInfo(int x, int y) {

  if (null != currentGml) {
    pushStyle();
    stroke(255);
    fill(255);
    text("TagID: "+currentTagID, x, y);
    text("Client: "+currentGml.client.name +" "+currentGml.client.version, x, y+=20);
    text("Username: "+currentGml.client.username, x, y+=20);
    text("Keywords: "+currentGml.client.keywords, x, y+=20);
    popStyle();
  }
}


private void parseGml(String file) {
  if (gp.isAvailable() && !(file.equals(""))) {
    if (local) {
      gp.parse(file);
    }
    else {
      gp.parse(proxyLocation+file);
    }
  }
}


private void loadNext() {
  if (null != nextGml) {
    currentGml = nextGml;
    nextGml = null;
    gdm.setGml(currentGml);
    currentTagID = getTagID(currentGml.client.permalink);
    if (autoMode) {
      nextFile = randomGmlUrl;
    }
  }
  reset();
}

private void reset() {
  gdm.reset();
  frameCount = 1;
}


public void keyReleased() {

  if (key == 'i' || key == 'I') {
    showClientInfo = !showClientInfo;
  }
  else if (key == 'h' || key == 'H') {
    showHelp = !showHelp;
  }

  else if (key == 'x' || key == 'X') {
    reset();
  }

  if (key == ' ') {
    nextFile = randomGmlUrl;
    autoMode = false;
  }

  else if (key == 'l' || key == 'L') {
    nextFile = latestGmlUrl;
    autoMode = false;
  }

  else if (key == 'a' || key == 'A') {
    nextFile = randomGmlUrl;
    autoMode = true;
  }


  else if ("0123456789".indexOf(""+key) > -1 && tagID.length() < 7) {
    tagID += key;
  }

  else if (keyCode == RETURN || keyCode == ENTER) {
    if (tagID.length() > 0) {
      autoMode = false;
      nextFile = "?tagid="+tagID;
      tagID = "";
    }
  }
  else if (keyCode == DELETE || keyCode == BACKSPACE) {
    if (tagID.length() > 0) {
      tagID = tagID.substring(0,tagID.length() -1);
    }
  }
}

/*
/ Obama custom drawer
/
/
*/

public class ObamaDrawer {

	private HashMap<Integer, LinkedList<GmlPoint>> strokes = new HashMap<Integer, LinkedList<GmlPoint>>();

	private GmlEnvironment environment;
	private Vec3D screen;
	private Vec3D graffScale = new Vec3D(1, 1, 1);

	GmlPoint last, next;
	Vec2D nextStrokeStart;

	public float ratio;

	public boolean finishedDrawing = false;
	public boolean finished = false;
	public boolean transition = false;
	private int prevStrokesSize = 0;


	Vec2D elbow, elbowSwitch, shoulder, pen, penpos, tag, transitionTarget;

	private float baseAngle = -0.1f;
	private float currentAngle = 0;
	private float angleRange = 0.08f;
	private int alpha = 255;

	boolean debug;
	PImage bodyImg, bodyShadowImg, armImg, armShadowImg;


	public ObamaDrawer(int width, int height, int depth, float ratio, PImage bodyShadowImg, PImage bodyImg, PImage armImg, PImage armShadowImg) {
		screen = new Vec3D(width, height, depth);
		this.ratio = ratio;

		this.bodyShadowImg = bodyShadowImg;
		this.armImg = armImg;
		this.bodyImg = bodyImg;
		this.armShadowImg = armShadowImg;

		last = new GmlPoint();
		elbow = new Vec2D(width-419, height-189);
		tag = new Vec2D(width-234, 213);
		pen = new Vec2D(204, 50);
		elbowSwitch = new Vec2D(-20, -75);
		shoulder = new Vec2D();
		
		transitionTarget = new Vec2D(width/2.5f, height/2.5f);
	}

	public void draw(PGraphics g) {

		if (strokes.size() > 0) {
			if(finishedDrawing) {

				alpha -= 3;

				// Transition
				if (tag.distanceTo(transitionTarget) > 3) {
					tag.interpolateToSelf(transitionTarget, 0.1f);
				}
				else {

					if (alpha < 0) {
						finished = true;
					}
				}

				drawArmShadow(g);
				drawLines(g, tag);
				drawArm(g);
			}
			else if (transition) {

				last.interpolateToSelf(next, 0.2f);
				calculateAngle(last.y);
				drawArmShadow(g);
				drawLines(g, tag);
				drawArm(g);
				if (last.distanceTo(next) <2) {
					transition = false;
				}
			}
			else {
				getCurrentPosition();
				calculateAngle(last.y);
				drawArmShadow(g);
				drawLines(g, tag);
				drawArm(g);
			}
		}
		else {
			getCurrentPosition();
			calculateAngle(last.y);
			drawArmShadow(g);
			drawArm(g);			
		}
	}

	private void calculateAngle(float h) {

		if (null != last) {
			float ratio = (graffScale.y-h)/graffScale.y;
			currentAngle = ratio*angleRange;
		}
		else {
			currentAngle = 0;
		}

		Vec2D tmpVec = new Vec2D(pen);

		tmpVec.addSelf(elbowSwitch);
		tmpVec.rotate(-(float) Math.PI*2* (baseAngle+currentAngle));
		tmpVec.addSelf(elbow);

		tag.set(tmpVec);
	}

	private void getCurrentPosition() {
		next = new GmlPoint();
		if (strokes.size() > 0) {
			if(strokes.get(strokes.size()-1).size() > 0) {

				next.set(strokes.get(strokes.size()-1).getLast());
				next.scaleSelf(graffScale);

				if (environment.up.x == 1) {
					next.rotateZ((float) -Math.PI/2);
				}
			}

		}

		if (strokes.size() > prevStrokesSize && strokes.size() > 1) {
			prevStrokesSize = strokes.size();
			strokes.remove(strokes.size()-1);
			transition = true;
			nextStrokeStart = next.to2DXY();
		}
		else {
			prevStrokesSize = strokes.size();
			last.set(next);			
		}		
	}


	private void drawArmShadow(PGraphics g) {
		g.image(bodyShadowImg, screen.x-bodyShadowImg.width, screen.y-bodyShadowImg.height);

		g.pushMatrix();
		g.translate(elbow.x, elbow.y); 
		g.rotate( -(float) Math.PI*2* (baseAngle + currentAngle));
		g.translate(elbowSwitch.x, elbowSwitch.y);
		g.image(armShadowImg, 0, 0);
		g.popMatrix();		
	}

	private void drawArm(PGraphics g) {

		g.pushMatrix();
		g.translate(elbow.x, elbow.y); 
		g.rotate( -(float) Math.PI*2* (baseAngle + currentAngle));
		g.translate(elbowSwitch.x, elbowSwitch.y);
		g.image(armImg, 0, 0);
		g.popMatrix();

		g.image(bodyImg, screen.x-bodyShadowImg.width, screen.y-bodyShadowImg.height);

	}


	private void drawLines(PGraphics g, Vec2D position) {

		g.pushMatrix();
		g.pushStyle();
		g.translate(position.x, position.y);
		g.translate(-last.x, -last.y);

		if (environment.up.x == 1) {
			g.rotate((float)-Math.PI/2);

		}
		else if (environment.up.y == 1) {
			// Tested OK
		}
		else if (environment.up.z == 1) {
			// TODO z up rotation
		}


		for (LinkedList<GmlPoint> points : strokes.values()) {

			if (points.size() > 0) {
				g.smooth();
				g.stroke(0, alpha);
				g.strokeWeight(1);

				// iterate over all points
				GmlPoint prev = new GmlPoint();
				GmlPoint cur = new GmlPoint();
				prev.set(points.getFirst().scale(graffScale));
				for(GmlPoint point: points) {
					cur.set(point.scale(graffScale));
					line(g, prev, cur);
					prev.set(cur);
				}
			}
		}
		g.popStyle();
		g.popMatrix();

	}


	private void line(PGraphics g, Vec3D a, Vec3D b) {
		g.line(a.x, a.y, b.x, b.y);
	}


	public void gmlEvent(GmlEvent event) {
		//synchronized(this) {

			if (event instanceof GmlDrawingStart) {
				strokes.clear();
				environment = ((GmlDrawingStart) event).environment;
				graffScale = GmlDrawingHelper.getGraffScale(screen, environment, ratio);
				finishedDrawing = false;
				prevStrokesSize = 0;
				alpha = 255;
			}

			else if (event instanceof GmlDrawingEvent) {
				if (((GmlDrawingEvent) event).points.size() > 0) {
					if (((GmlDrawingEvent)event).points.size() > 0) {
						this.strokes.put(((GmlDrawingEvent) event).strokeId, ((GmlDrawingEvent) event).points);
					}
				}
			}

			else if (event instanceof GmlDrawingEnd) {

				finishedDrawing = true;
			}
		//}
	}
}
*/
