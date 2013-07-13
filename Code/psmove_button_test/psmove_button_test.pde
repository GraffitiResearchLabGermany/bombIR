
// Import the PS Move API Package
import io.thp.psmove.*;

MoveController [] moves;

void setup() {
  moves = new MoveController[psmoveapi.count_connected()];
  for (int i=0; i<moves.length; i++) {
    moves[i] = new MoveController(i);
  }
}

void draw() {
  
  for (int i=0; i<moves.length; i++) {
    moves[i].movePoll(); // Take care of each move controller
  }
  
}

class MoveController extends PSMove {
  
  MoveController(int i) {
    super(i);
    movePoll();
  }
  
  void movePoll() {
    while ( super.poll() != 0 ) { println("inside of while super.poll"); }
    
    int buttons = super.get_buttons();
    
    if ((buttons & Button.Btn_MOVE.swigValue()) != 0) {
     println("The MOVE button is currently pressed.");
   }
  }
}
