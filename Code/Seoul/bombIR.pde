   
//-----------------------------------------------------------------------------------------
/*
 * bombIR
 * ---------------------------------------------------------------------------
 * Graffiti Research Lab Germany      |   Graffiti Research Lab Canada
 * www.graffitiresearchlab.de         |   www.graffitiresearchlab.ca
 * ----------------------------------------------------------------------------
 * License:
 * Licensed according to the 
 * Attribution-Non-Commercial-Repurcussions 3.0 Unported (CC BY-NC 3.0)
 * as per 
 * http://www.graffitiresearchlab.fr/?portfolio=attribution-noncommercial-repercussions-3-0-unported-cc-by-nc-3-0
 * 
 * ----------------------------------------------------------------------------
 * Credits
 * _______
 * 
 * Programming (v2.0):  
 *               Jesse Scott + Hauke Altmann
 * 
 * Original Programming:
 *               Jesse Scott + Ed Jordan, with help from the Banff New Media Institute
 *
 *  Libraries
 *  _________
 * 
 *  OscP5          - Andreas Schlegel
 *  GML4U          - Jerome St.Clair
 *  ToxiLibs       - Karsten Schmidt
 *  Fullscreen     - ...
 *  Video          - Ben Frey & Casey Reas
 *  BlobDetection  - Julien (V3GA) 
 *
 * ----------------------------------------------------------------------------
 */
//-----------------------------------------------------------------------------------------

// IMPORTS
//-----------------------------------------------------------------------------------------

import deadpixel.keystone.*;
import controlP5.*;

import processing.video.*;
import blobDetection.*;

import oscP5.*;
import netP5.*;

import gml4u.brushes.*;
import gml4u.drawing.GmlBrushManager;
import gml4u.drawing.GmlDrawingManager;
import gml4u.events.GmlEvent;
import gml4u.events.GmlParsingEvent;
import gml4u.events.GmlStrokeEndEvent;
import gml4u.model.GmlBrush;
import gml4u.model.GmlConstants;
import gml4u.model.GmlStroke;
import gml4u.model.Gml;
import gml4u.recording.GmlRecorder;
import gml4u.utils.GmlParser;
import gml4u.utils.GmlParsingHelper;
import gml4u.utils.Timer;
import gml4u.utils.GmlSaver;

import toxi.geom.Vec3D;

import java.util.Properties;
import java.awt.Frame;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.List;

//import fullscreen.*;
//import japplemenubar.*;

import javax.jms.*;
import java.util.UUID;
import gml4u.utils.GmlSavingHelper;
import gml4u.utils.Timer;
import projms.publisher.Publisher;
import projms.consumer.Consumer;
import projms.util.SimpleQueue;

import bombir.brushes.*;

  
// DECLARATIONS
//-----------------------------------------------------------------------------------------  

// Video
Capture cam;
BlobDetection bd;

// Keystone
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

// CP5
ControlP5 cp5;
RadioButton rb;

// OSC
OscP5 oscP5;
    
// GML    
GmlRecorder recorder;
GmlParser parser;
GmlSaver saver;
GmlBrushManager brushManager;
GmlBrush brush;

// Graphics Buffers
PGraphics pg;
PGraphics cp;

//Windows
//secondApplet s;
PFrame f2;
//SoftFullScreen fs; 

// Text
PFont calibFont;

//Messaging
Timer timer;
Publisher messagePublisher;
GmlRecorder messagingRecorder;
MessageConsumer mc, mc2;

//Settings
P5Properties properties, camProperties;

// GLOBAL VARIABLES
//-----------------------------------------------------------------------------------------

// Brushes
float brushR = 255;
float brushG = 255;
float brushB = 255;
float brushA = 255;
int   brushMode = 1;
int   brushSize = 5;

// Drips
Drop [] drips;
int numDrips = 0;

// Images
PImage logo, license;
PImage circle, pencil, marker, chisel, spray, drip, eraser, sizes;

// GUI Markers
int brushPicked = 12; // colour brush
int dripsPicked; // colour drips
int sizePicked = 695; // brush size 

// GML
float scale;

// System
//int UseOpenGL, UseSecondScreen;

// Settings
int DrawMode;
int NumScreens;
int FirstScreenWidth, FirstScreenHeight, FirstScreenOffset; 
int SecondScreenWidth, SecondScreenHeight, SecondScreenOffset;
int ThirdScreenWidth, ThirdScreenHeight, ThirdScreenOffset;
int FourthScreenWidth, FourthScreenHeight, FourthScreenOffset;
String FirstBrokerLocation, FirstBrokerTopic;
String SecondBrokerLocation, SecondBrokerTopic;
String EditorBrokerLocation, EditorBrokerTopic;

int CameraID, CameraWidth, CameraHeight;
String Recalibrate;
float LeftBorder, RightBorder, TopBorder, BottomBorder;

// Calibrate
boolean calibrate = false;
int adjustBox;
String instructions;
int calibSubState = 8;
boolean calibShowCam, calibShowBlob;

//
boolean dripsIO = false;
boolean clicked = false;
boolean showCursor = false;
float currFrame = 0;
float elapsedFrame;
int saveCount = 0;

// DRAW
float drawX, drawY;
float pdrawX, pdrawY;
float oscX, oscY; int oscIO;
float gmlX, gmlY;
float camX, camY; int camIO;

// OSC
int saveMSG = 0;
int clearMSG = 0;

// Blob
float blobMin = 0.025;      
float blobMax = 0.15;
float blobThresh = 0.5;
float blobX, blobY;
int blobIO;
int prevBlobFrame;
float sumBlobsX, sumBlobsY;
int blobCount;

// GUI
int menuHeight = 100;
int menuWidth = 1024;
int cpSize = int(menuHeight * 0.8);
int picker;


//-----------------------------------------------------------------------------------------
  

