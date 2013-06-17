

void sendStrokeMessage(String gml){
  messagePublisher.sendMessage(gml,"STROKE", EditorBrokerTopic);
  println("SENDING to " + EditorBrokerTopic);
}


void sendClearScreenMessage(){
 messagePublisher.sendMessage("","CLEAR", EditorBrokerTopic);
}


//-----------------------------------------
// Class for MessagingConsumer screens
public class ConsumerApplet extends PApplet {
    
    Consumer messageConsumer;
    GmlBrushManager bm;
    GmlDrawingManager dm;
    GmlBrush br;
    Gml currentGml;
    Timer ctime;
    SimpleQueue<Gml> gmlQ;
    PGraphics pg;
    
    float sc;
    int screenWidth;
    int screenHeight;
    
    public ConsumerApplet(String URI, String topic, int screenWidth, int screenHeight){
      this.screenWidth = screenWidth;
      this.screenHeight = screenHeight; 
      messageConsumer = new Consumer(this, URI, topic);  // ADDED

    }
    
    public void setup() {
      size(screenWidth, screenHeight);
      background(0);
      smooth();
      sc = FirstScreenWidth;
      pg = createGraphics(screenWidth, screenHeight,   JAVA2D); 
      bm = new GmlBrushManager(this);
      dm = new GmlDrawingManager(this);
      gmlQ = new SimpleQueue<Gml>();
     
      bm.add(new FwdSlash());
      bm.add(new Circle());
      bm.add(new SimpleLine());
      bm.add(new FatCap());
      bm.add(new GhettoPaint());
      br = new GmlBrush();
      
      ctime = new Timer();
      ctime.setStep(0.01f);
    }
 
    public void draw() {
      if(pg != null) {
         
          pg.beginDraw();
            pg.smooth();
            if (currentGml != null) {
              ctime.tick();
              bm.draw(pg, currentGml, scale, ctime.getTime(), ctime.getTime()+0.1f);
              dm.pulse(ctime.getTime());  
            }
          pg.endDraw();
          image(pg,0,0);
       
      }
    }
    
    void onMessageArrival(String messageText, String messageType){
	System.out.println("Message: \n" + messageText); 
	System.out.println("MessageType: \n" + messageType); 

	if(messageType.equals("CLEAR")){
	  pg.background(0);
          currentGml = null;
          gmlQ.clear();
          
	}else{
  
          Gml gml = GmlParsingHelper.getGmlFromString(messageText, false);
          List<GmlStroke> strokes = (List<GmlStroke>)gml.getStrokes();
          if(strokes.size() < 1){
        	return;
          }     
	  gmlQ.put(gml);
          if(currentGml == null){
            this.gmlEvent(new GmlStrokeEndEvent(new GmlStroke()));
            println("event fired");
          }
        }
    }
    
    public void stop(){
      try{
        this.messageConsumer.close();
      }catch(JMSException ex){
        System.out.println(ex.getMessage());
      }
    }
    
    public void gmlEvent(GmlEvent event) {
      if (event instanceof GmlStrokeEndEvent){
        if(gmlQ.size() > 0){
          currentGml = gmlQ.get();
          dm.setGml(currentGml);
          ctime.start();
        }else{
          currentGml = null;
        }
      }
  }    
}

//Threaded MessagConsumer
public class MessageConsumer extends Thread {
  protected ConsumerApplet consumer;
  protected PFrame frame;
  protected int offset = 0;
  protected int width = 640;
  protected int height = 480;
  protected String brokerLocation;
  protected String messagingTopic;
  
  
  public void start(){
    System.out.println("Starting thread for "); 
    if(this.brokerLocation == null || this.messagingTopic == null){
      System.out.println("brokerLocation and messagingTopic need to be set before starting the messageconsumer");
      return;
    }
    this.consumer = new ConsumerApplet(this.brokerLocation, this.messagingTopic, this.width, this.height);
    this.frame = new PFrame(this.consumer, this.offset, this.width, this.height);

    super.start();
  }
  
  public void setFrameSize(int offset, int width, int height){
    this.offset = offset;
    this.width = width;
    this.height = height;
    
  }
  
  public void setBrokerLocation(String location){
    this.brokerLocation = location;
  }
  
  public void setMessagingTopic(String topic){
    this.messagingTopic = topic;
  }
  
  public void run(){
    //nothing to be done here yets
  }
  
  public void quit(){
    this.consumer.stop();
    interrupt();
  }
}



