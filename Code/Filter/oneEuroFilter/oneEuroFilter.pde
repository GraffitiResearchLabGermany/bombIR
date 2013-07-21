
// Implementation of the 1€ filter [Casiez 2012] for the Processing environment
// http://www.lifl.fr/~casiez/publications/CHI2012-casiez.pdf

// Based on the Java version by Stéphane Conversy from Université de Toulouse
// http://lii-enac.fr/~conversy/

// Try the online version by Jonathan Aceituno: http://oin.name/1eurofilter/

// Tweaked by Raphaël de Courville 
// for Graffiti Research Lab Germany 
// (July 2013)
// Twitter: @sableRaph, @GRLGermany


OneEuroFilter oneEuroX;
OneEuroFilter oneEuroY;


// “if high speed lag is a problem, increase β [beta]; 
// if slow speed jitter is a problem, decrease fcmin [mincutoff].”
  
double frequency = 120;    // Hz
double mincutoff = 3.0;   // Minimum cutoff (intercept)
double beta      = 0.00700; // Cutoff slope
double dcutoff   = 1.0;   // Cutoff for derivative

void setup() {
  
    size(1024, 768);
    frameRate((int)frequency);
  
    try {
     oneEuroX = new OneEuroFilter(frequency, mincutoff, beta, dcutoff);
    }
    catch (Exception e) {
     e.printStackTrace();
    }
    
    try {
     oneEuroY = new OneEuroFilter(frequency, mincutoff, beta, dcutoff);
    }
    catch (Exception e) {
     e.printStackTrace();
    }
    
}


void draw()
{
  
  background(180);
  
  noFill();
  strokeWeight(5);
  
  // draw ellipse at actual position
  //stroke(100, 100, 100);
  //ellipse(mouseX, mouseY, 10, 10);
  
  float noiseX = mouseX + random(-5,+5);
  float noiseY = mouseY + random(-5,+5);
  
  PVector noisePos = new PVector(noiseX, noiseY);
  
  println("");
  println("noisePos    = " + noisePos);
  
  // Draw a small ellipse at noisy position
  pushStyle();
  pushMatrix();
  stroke(0);
  strokeWeight(1);
  fill(255);
  translate(noiseX,noiseY);
  ellipse(0, 0, 5, 5);
  popMatrix();
  popStyle();
  
  float filteredX = 0.0;
  float filteredY = 0.0;
  
  //perform the 1 euro filtering (unit values)   
  try {
     filteredX = (float) oneEuroX.filter( noiseX / width, frameCount / frequency ) * width;
  }
  catch (Exception e) {
   e.printStackTrace();
  }
  
  try {
     filteredY = (float) oneEuroY.filter( noiseY / height, frameCount / frequency ) * height;
  }
  catch (Exception e) {
   e.printStackTrace();
  }
    
  PVector filteredPos = new PVector( filteredX, filteredY );
  
  println( "filteredPos = " + filteredPos );
  
  // Draw PURPLE ellipse at filtered position
  pushStyle();
  pushMatrix();
  translate(filteredPos.x, filteredPos.y);
  stroke(146, 11, 254); // Purple
  ellipse(0, 0, 45, 45);
  fill(146, 11, 254);
  text("1€ Filter", 30, -20);
  popMatrix();
  popStyle();  
  
}



/**
 *
 * @author s. conversy from n. roussel c++ version
 */
class LowPassFilter {

    double y, a, s;
    boolean initialized;

    void setAlpha(double alpha) throws Exception {
        if (alpha <= 0.0 || alpha > 1.0) {
            throw new Exception("alpha should be in (0.0, 1.0] and is now "+ alpha);
        }
        a = alpha;
    }

    public LowPassFilter(double alpha) throws Exception {
        init(alpha, 0);
    }

    public LowPassFilter(double alpha, double initval) throws Exception {
        init(alpha, initval);
    }

    private void init(double alpha, double initval) throws Exception {
        y = s = initval;
        setAlpha(alpha);
        initialized = false;
    }

    public double filter(double value) {
        double result;
        if (initialized) {
            result = a * value + (1.0 - a) * s;
        } else {
            result = value;
            initialized = true;
        }
        y = value;
        s = result;
        return result;
    }

    public double filterWithAlpha(double value, double alpha) throws Exception {
        setAlpha(alpha);
        return filter(value);
    }

    public boolean hasLastRawValue() {
        return initialized;
    }

    public double lastRawValue() {
        return y;
    }
}

class OneEuroFilter {

    double freq;
    double mincutoff;
    double beta_;
    double dcutoff;
    LowPassFilter x;
    LowPassFilter dx;
    double lasttime;
    double UndefinedTime = -1;

    double alpha(double cutoff) {
        double te = 1.0 / freq;
        double tau = 1.0 / (2 * Math.PI * cutoff);
        return 1.0 / (1.0 + tau / te);
    }

    void setFrequency(double f) throws Exception {
        if (f <= 0) {
            throw new Exception("freq should be >0");
        }
        freq = f;
    }

    void setMinCutoff(double mc) throws Exception {
        if (mc <= 0) {
            throw new Exception("mincutoff should be >0");
        }
        mincutoff = mc;
    }

    void setBeta(double b) {
        beta_ = b;
    }

    void setDerivateCutoff(double dc) throws Exception {
        if (dc <= 0) {
            throw new Exception("dcutoff should be >0");
        }
        dcutoff = dc;
    }

    public OneEuroFilter(double freq) throws Exception {
        init(freq, 1.0, 0.0, 1.0);
    }

    public OneEuroFilter(double freq, double mincutoff) throws Exception {
        init(freq, mincutoff, 0.0, 1.0);
    }

    public OneEuroFilter(double freq, double mincutoff, double beta_) throws Exception {
        init(freq, mincutoff, beta_, 1.0);
    }

    public OneEuroFilter(double freq, double mincutoff, double beta_, double dcutoff) throws Exception {
        init(freq, mincutoff, beta_, dcutoff);
    }

    private void init(double freq, double mincutoff, double beta_, double dcutoff) throws Exception {
        setFrequency(freq);
        setMinCutoff(mincutoff);
        setBeta(beta_);
        setDerivateCutoff(dcutoff);
        x = new LowPassFilter(alpha(mincutoff));
        dx = new LowPassFilter(alpha(dcutoff));
        lasttime = UndefinedTime;
    }

    double filter(double value) throws Exception {
        return filter(value, UndefinedTime);
    }

    double filter(double value, double timestamp) throws Exception {
        // update the sampling frequency based on timestamps
        if (lasttime != UndefinedTime && timestamp != UndefinedTime) {
            freq = 1.0 / (timestamp - lasttime);
        }
        
        lasttime = timestamp;
        // estimate the current variation per second
        double dvalue = x.hasLastRawValue() ? (value - x.lastRawValue()) * freq : 0.0; // FIXME: 0.0 or value?
        double edvalue = dx.filterWithAlpha(dvalue, alpha(dcutoff));
        // use it to update the cutoff frequency
        double cutoff = mincutoff + beta_ * Math.abs(edvalue);
        // filter the given value
        return x.filterWithAlpha(value, alpha(cutoff));
    }
}



    

