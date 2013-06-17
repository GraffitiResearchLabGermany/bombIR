

//-----------------------------------------------------------------------------------------
// FRAME

// Second Applet / Frame
public class PFrame extends Frame {
  PApplet s;  
  public PFrame(PApplet applet, int ScreenOffset, int ScreenWidth, int ScreenHeight) {
        setBounds(ScreenOffset, 0, ScreenWidth, ScreenHeight);
        s = applet;
        add(s);
        removeNotify(); 
        setUndecorated(true);   //
        setResizable(false);
        addNotify(); 
        setLocation(ScreenOffset, 0);
        s.init();
        //show();
        setVisible(true);
    }
}

// Init First Frame
public void init() {
  frame.removeNotify(); 
  frame.setUndecorated(true);   //
  frame.setResizable(false);
  frame.addNotify(); 
  super.init();
}


//-----------------------------------------


