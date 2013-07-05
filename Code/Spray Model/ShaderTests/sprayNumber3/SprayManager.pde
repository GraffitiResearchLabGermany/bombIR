
class SprayManager {
 
 ArrayList<Path> strokeList;
 PGraphics targetBuffer;
 
 color col;
 float size;
 
 SprayManager() {
   strokeList = new ArrayList<Path>();
   col = color(0);
 }
  
 SprayManager(PGraphics buffer) {
   targetBuffer = buffer;
   strokeList = new ArrayList<Path>();
   col = color(0);
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
   
   Knot startingKnot = new Knot(x, y, weight, col);
   
   Path p = new Path(startingKnot);

   if (null!=targetBuffer)  
     p.setBuffer(targetBuffer);
 
   strokeList.add(p);
   
 }
 
 void newKnot(float x, float y, float weight) {
   
   Knot newKnot = new Knot(x, y, weight, col);
   
   Path activePath = getActivePath();
   activePath.add(newKnot);
   
 }
 
 Path getActivePath() {
   return strokeList.get( strokeList.size() - 1 );
 }
 
 void setWeight(float weight) {
   size = weight;
 }
 
 void setColor(color tint) {
   col = tint;
 }
 
 color getColor() {
   return col;
 }

}
