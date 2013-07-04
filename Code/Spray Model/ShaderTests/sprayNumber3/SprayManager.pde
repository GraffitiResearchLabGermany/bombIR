
class SprayManager {
 
 ArrayList<Path> strokeList;
 PGraphics targetBuffer;
 
 SprayManager() {
   strokeList = new ArrayList<Path>();
 }
  
 SprayManager(PGraphics buffer) {
   targetBuffer = buffer;
   strokeList = new ArrayList<Path>();
 }
 
 // Draw newly added points
 void draw() {
   for(Path p: strokeList) {
     p.draw();
   }
 }
 
 // Clear the strokes
 void clearAll() {
   
   for(Path p: strokeList) {
     p.clear();
   }
   
   strokeList.clear();
 }
 
 void newStroke(float x, float y, float weight) {
   
   Knot startingKnot = new Knot(x, y, weight);
   
   Path p = new Path(startingKnot);

   if (null!=targetBuffer)  
     p.setBuffer(targetBuffer);
 
   strokeList.add(p);
   
 }
 
 void newKnot(float x, float y, float weight) {
   
   Knot newKnot = new Knot(x, y, weight);
   
   Path activePath = getActivePath();
   activePath.add(newKnot);
   
 }
 
 Path getActivePath() {
   return strokeList.get( strokeList.size() - 1 );
 }

}
