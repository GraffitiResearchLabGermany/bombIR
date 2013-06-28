
//-----------------------------------------------------------------------------------------

public void oscEvent(OscMessage msg) {
  
  if(msg.checkAddrPattern("/Width") && msg.checkTypetag("f")) {
    float bS = map(msg.get(0).floatValue(), 0.1, 1.0, 1, 50);  
    brushSize = int(bS);
    //println("Got New Width... " + brushSize);
  }
  
  else if(msg.checkAddrPattern("/Red") && msg.checkTypetag("f")) {
      float nR = map(msg.get(0).floatValue(), 0.1, 1.0, 1, 255);  
      brushR = int(nR);
      //println("Got New Red... " + brushR);
  }
  
  else if(msg.checkAddrPattern("/Green") && msg.checkTypetag("f")) {
      float nG = map(msg.get(0).floatValue(), 0.1, 1.0, 1, 255);  
      brushG = int(nG);
      //println("Got New Green... " + brushG);
  }
  
  else if(msg.checkAddrPattern("/Blue") && msg.checkTypetag("f")) {
      float nB = map(msg.get(0).floatValue(), 0.1, 1.0, 1, 255);  
      brushB = int(nB);
      //println("Got New Blue... " + brushB);
  }
  
  else if(msg.checkAddrPattern("/saveMSG") && msg.checkTypetag("i")) {
    //println("Got Save Msg");
    saveMSG = msg.get(0).intValue();
    if(saveMSG == 1) { 
      //saveMSG = 0;
    }
  }
  
  else if(msg.checkAddrPattern("/clearMSG") && msg.checkTypetag("i")) {
    println("Got Clear Msg");
    clearMSG = msg.get(0).intValue();
    if(clearMSG == 1) {
      //clearMSG = 0;
    }
  }
  
  else if(msg.checkAddrPattern("/xy") && msg.checkTypetag("iff")) {
    oscIO = msg.get(0).intValue();
    oscX  = msg.get(1).floatValue();
    oscY  = msg.get(2).floatValue();
    //println("Drawing from phone " + recX + " " + recY);
  }

 
} //--

//-----------------------------------------------------------------------------------------

