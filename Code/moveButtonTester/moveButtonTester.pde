
// Import the PS Move API Package
import io.thp.psmove.*;

PSMove [] moves;
color sphereColor;

void setup() {
  moves = new PSMove[psmoveapi.count_connected()];
  for (int i=0; i<moves.length; i++) {
    moves[i] = new PSMove(i);
  }
}

void draw() {
  
  for (int i=0; i<moves.length; i++) {
    handle(i, moves[i]); // Take care of each move controller
  }
  
}

void handle(int i, PSMove move)
{
   
   while (move.poll () != 0) {
        
        // Default is white
        sphereColor = color(255, 255, 255);
     
        int trigger = move.get_trigger();
        if(trigger == 255) {
            sphereColor = color(255, 0, 0); // Trigger = red
        }
        
        int buttons = move.get_buttons();
        if ((buttons & Button.Btn_SQUARE.swigValue()) != 0) {
            sphereColor = color(0, 255, 0); // Square = green
       }
       
       if ((buttons & Button.Btn_TRIANGLE.swigValue()) != 0) {
            sphereColor = color(0, 0, 255); // Triangle = blue
       }
   }
   
   int r = (int) red   (sphereColor);
   int g = (int) green (sphereColor);
   int b = (int) blue  (sphereColor);
   move.set_leds(r,g,b); 
   move.update_leds();
}
