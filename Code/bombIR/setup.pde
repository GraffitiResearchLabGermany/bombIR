
//-----------------------------------------------------------------------------------------
// SETUP

void setup() {
 
  // Reading settings.properties File
  try {
    println("Reading Properties");
    properties = new P5Properties();
    properties.load(openStream("settings.properties"));
 
    NumScreens = properties.getIntProperty("env.view.numscreens",1);
    DrawMode = properties.getIntProperty("env.view.drawmode",1);
    
    //editor window
    FirstScreenOffset = properties.getIntProperty("env.view.firstscreen.offset", 0);
    FirstScreenWidth = properties.getIntProperty("env.view.firstscreen.width",640);
    FirstScreenHeight = properties.getIntProperty("env.view.firstscreen.height",480);
    EditorBrokerLocation = properties.getProperty("remote.editor.broker.uri", "peer://group1/" + UUID.randomUUID().toString());
    EditorBrokerTopic = properties.getProperty("remote.editor.broker.topic", "TCP.BERLIN");
    
    //projection window
    SecondScreenOffset = properties.getIntProperty("env.view.secondscreen.offset",55);
    SecondScreenWidth = properties.getIntProperty("env.view.secondscreen.width",640);
    SecondScreenHeight = properties.getIntProperty("env.view.secondscreen.height",480);
    
    //first remote source
    ThirdScreenOffset = properties.getIntProperty("env.view.thirdscreen.offset",55);
    ThirdScreenWidth = properties.getIntProperty("env.view.thirdscreen.width",640);
    ThirdScreenHeight = properties.getIntProperty("env.view.thirdscreen.height",480);
    FirstBrokerLocation = properties.getProperty("remote.first.broker.uri", "peer://group1/" + UUID.randomUUID().toString());
    FirstBrokerTopic = properties.getProperty("remote.first.broker.topic", "TCP.BERLIN");
    
    //second remote source
    FourthScreenOffset = properties.getIntProperty("env.view.fourthscreen.offset",55);
    FourthScreenWidth = properties.getIntProperty("env.view.fourthscreen.width",640);
    FourthScreenHeight = properties.getIntProperty("env.view.fourthscreen.height",480);
    SecondBrokerLocation = properties.getProperty("remote.second.broker.uri", "peer://group1/" + UUID.randomUUID().toString());
    SecondBrokerTopic = properties.getProperty("remote.second.broker.topic", "TCP.BERLIN");
    println();
  }
  catch(IOException e) {
    e.printStackTrace();
    println("couldn't read config file...");
    exit();
  }
  
  // Reading settings.camera.properties File
  try {
    println("Reading Camera Properties");
    camProperties = new P5Properties();
    camProperties.load(openStream("settings.camera.properties"));

    // Camera Settings
    CameraID     = camProperties.getIntProperty("cam.settings.cameraid",1);
    CameraWidth  = camProperties.getIntProperty("cam.settings.camerawidth",320);
    CameraHeight = camProperties.getIntProperty("cam.settings.cameraheight",240);
    
    // Calibration Settings
    Recalibrate    = camProperties.getProperty("calib.settings.recalibrate", "NO");
    LeftBorder     = camProperties.getFloatProperty("calib.settings.left", 0.0) * FirstScreenWidth;
    RightBorder    = camProperties.getFloatProperty("calib.settings.right", 1.0) * FirstScreenWidth;
    TopBorder      = camProperties.getFloatProperty("calib.settings.top", 0.0) * FirstScreenHeight;
    BottomBorder   = camProperties.getFloatProperty("calib.settings.bottom", 1.0) * FirstScreenHeight;
    println();
    
    // Blob Tracking Settings
    //blobMin        = camProperties.getFloatProperty("track.blob.min", 0.05);      
    //blobMax        = camProperties.getFloatProperty("track.blob.max", 0.15);
    //blobThresh     = camProperties.getFloatProperty("track.blob.thresh", 0.5);
    println();  
  }
  catch(IOException e) {
    e.printStackTrace();
    println("couldn't read camera file...");
    exit();
  }

  // Screen stuff

  
  size(FirstScreenWidth, FirstScreenHeight + menuHeight, P2D);
  background(0);
  smooth();
  println();
  
  // Offset
  frame.setLocation(FirstScreenOffset,0);
  
  // Remote Screen(s)
  if(NumScreens >= 2){
    mc = new MessageConsumer();
    mc.setFrameSize(ThirdScreenOffset,ThirdScreenWidth,ThirdScreenHeight);
    mc.setBrokerLocation(FirstBrokerLocation);
    mc.setMessagingTopic(FirstBrokerTopic);
    mc.start();
  }
  if(NumScreens >= 3){
    mc2 = new MessageConsumer();
    mc2.setFrameSize(FourthScreenOffset,FourthScreenWidth,FourthScreenHeight);
    mc2.setBrokerLocation(SecondBrokerLocation);
    mc2.setMessagingTopic(SecondBrokerTopic);
    mc2.start();
  }
  
  // Video Capture
  String[] devices = Capture.list();
  println("Available Cameras:");
  println(devices);
  //cam = new GSCapture(this, CameraWidth, CameraHeight, "Sony HD Eye for PS3 (SLEH 00201)");
  //cam.start();
  cam = new Capture(this, CameraWidth, CameraHeight, devices[CameraID]);
  println();
  
  // Blob Detection
  bd = new BlobDetection(cam.width, cam.height);
  bd.setPosDiscrimination(true);
  bd.setThreshold(blobThresh);

  // Graphics Buffers
  pg  = createGraphics(FirstScreenWidth, FirstScreenHeight, JAVA2D);  
  cp = createGraphics(1024, cpSize, JAVA2D); 
 
  // Drips
  drips = new Drop[6000];
  
  // OSC
  oscP5 = new OscP5(this, 11000);
  println();
  
  // GML
  Vec3D screen = new Vec3D(width, height, 0);
  scale = width;
  float minimumStrokeLength = 0.01f; // Default value when omitted
  float minimumPointsDistance = 0.001f; // Default value when omitted
  recorder = new GmlRecorder(screen, minimumStrokeLength, minimumPointsDistance);
  
  brushManager = new GmlBrushManager();
  brushManager.add(new Circle());
  brushManager.add(new FwdSlash());
  brushManager.add(new SimpleLine());
  brushManager.add(new FatCap());
  brushManager.add(new GhettoPaint());
  
  saver = new GmlSaver(500, "", this);
  saver.start();    
  println();
  
  // Images
  logo =   loadImage("info/logo.png");
  chisel = loadImage("icons/chisel.jpg");
  circle = loadImage("icons/circle.jpg");
  marker = loadImage("icons/marker.jpg");
  pencil = loadImage("icons/pencil.jpg");
  spray =  loadImage("icons/spray.jpg");
  drip =   loadImage("icons/drips.jpg");
  eraser = loadImage("icons/eraser.jpg");
  sizes =  loadImage("icons/sizes.jpg");
  
  // CP5
  println("Minimum Blob Size Set To " + blobMin);
  println("Minimum Blob Size Set To " + blobMax);
  println("Minimum Blob Size Set To " + blobThresh);
  cp5 = new ControlP5(this);
  cp5.addToggle("CAM", 250, FirstScreenHeight + 25, menuHeight/4, menuHeight/4);
  cp5.addToggle("BLB", 300, FirstScreenHeight + 25, menuHeight/4, menuHeight/4);
  cp5.addBang("SaveSettings")
     .setPosition(350, FirstScreenHeight + 25)
     .setSize(25, 25)
     ;
//  cp5.addNumberbox("BlobMin")
//     .setPosition(325, FirstScreenHeight + 25)
//     .setSize(50,25)
//     .setRange(0,1)
//     .setMultiplier(0.01) 
//     .setDirection(Controller.HORIZONTAL) 
//     .setValue(blobMin)
//     ;
//  cp5.addNumberbox("BlobMax")
//     .setPosition(400, FirstScreenHeight + 25)
//     .setSize(50, 25)
//     .setRange(0,1)
//     .setMultiplier(0.01) 
//     .setDirection(Controller.HORIZONTAL) 
//     .setValue(blobMax)
//     ;
//  cp5.addNumberbox("BlobThresh")
//     .setPosition(475, FirstScreenHeight + 25)
//     .setSize(50, 25)
//     .setRange(0,1)
//     .setMultiplier(0.01) 
//     .setDirection(Controller.HORIZONTAL)
//     .setValue(blobThresh)
//     ;  
  rb = cp5.addRadioButton("CropBox")
     .setPosition(25, FirstScreenHeight + 25)
     .setSize(25, 25)
     .setColorForeground(color(120))
     .setColorActive(color(255))
     .setColorLabel(color(255))
     .setItemsPerRow(4)
     .setSpacingColumn(25)
     .addItem("LEFT", 1)
     .addItem("RIGHT", 2)
     .addItem("TOP", 3)
     .addItem("BOTTOM", 4)
     ;
     
  // Publishing
  messagePublisher = new Publisher(EditorBrokerLocation, this);
  
  timer = new Timer();
  timer.setStep(0.01f);
  messagingRecorder = new GmlRecorder(screen, minimumStrokeLength, minimumPointsDistance);
  brush = new GmlBrush();
  brush.set("size", String.valueOf(brushSize));
  brush.set("alpha", String.valueOf(brushA));
  brush.set("red", String.valueOf(brushR));
  brush.set("blue", String.valueOf(brushB));
  brush.set("green", String.valueOf(brushG));
  brush.set("uniqueStyleID", Circle.ID);
  
  // Colour Picker
  cp.beginDraw();
    cp.colorMode(HSB, cpSize);
    for (int i = 0; i < cpSize; i++) {
      for (int j = 0; j < cpSize; j++) {
        cp.stroke(i, j, i+j);
        cp.point( (475) - i, cpSize - j);
      }
    }
  cp.endDraw();
  
  // Calibration
  if(Recalibrate.equals("YES")) {
    println();
    println(" About To Calibrate...");  
    calibFont = createFont("onscreen", 24);
    calibrate = true;
  }
  else {
    println();
    println("Skipping Calibration...");
    calibrate = false; 
  }

  frameRate(120);
  
  println();
  println("----------------------");
  println("    END OF SETUP  ");
  println("----------------------");
  println();
  
} // end SETUP
  
  //-----------------------------------------------------------------------------------------
