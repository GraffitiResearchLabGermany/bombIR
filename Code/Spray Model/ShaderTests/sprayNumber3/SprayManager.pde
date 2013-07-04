
class SprayManager {
 
 ArrayList<Path> strokeList;
 PGraphics canevas;
  
 SprayManager(PGraphics c) {
   canevas = c;
   strokeList = new ArrayList<Path>();
 }
 
 // Draw newly added points
 void draw() {
   for(Path p: strokeList) {
     p.draw(canevas);
   }
 }
 
 // Clear the strokes
 void clearAll() {
   
   for(Path p: strokeList) {
     p.clear();
   }
   
   strokeList.clear();
   
 }
 
 void newStroke() {
   Path p = new Path();
   strokeList.add(p);
 }
 
 // 
 void addPoint(PVector pos, float weight, color col) {
   
   Knot newKnot    = new Knot(pos, weight, col);
   
   Path activePath = getActivePath();
   activePath.add(newKnot);
   
 }
 
 Path getActivePath() {
   return strokeList.get( strokeList.size() - 1 );
 }

}
