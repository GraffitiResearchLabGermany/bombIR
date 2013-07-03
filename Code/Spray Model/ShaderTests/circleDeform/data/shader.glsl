 // This shader example is adapted from the Andrew Baldwin's 
 // introductory tutorials to GLSL. Find them at http://thndl.com

// This shader belongs to 
// color_04_circle.pde

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

#define TWO_PI 6.2831853071795865
#define PI 3.1415926535897932384

uniform vec2 resolution;
uniform vec2 direction;

float getFlare(float angle, float amount) {
  
  // Linear function
  float Lin = angle;

  // x = x^3
  float Pw3 = (pow( angle * 6.0 - 3.0, 3.0 ) + 27.0) / 54.0;

  // The angle of incidence defines how much the spray actually flares
  float mix = mix( Pw3, Lin, amount );

  // The envelope is the diff between the power and linear functions
  float Env = mix - Lin;
  
  // Target function
  float A = 0.5; // Amplitude
  float p = 1.0; // period
  float t = angle + Env; // time
  float d = 0.25; //shift 
  float B = 0.5; // center
  float range = TWO_PI;
  
  float Sin = A * sin( (range / p) * (d - t) ) + B;

  float flare = Sin;

  return flare;
}

// smoothing
float smoother(float y) {
	float s = 1.0 / resolution.y;
	float shade = smoothstep( y+s, y-s, gl_FragCoord.y / resolution.y );
	return shade;
}

void main(void)
{ 
	// We compute the position of the current fragment (from [-1,-1] to [1,1])
 	vec2 coord = vec2 (-1.0 + 2.0 * gl_FragCoord.x / resolution.x, 1.0 - 2.0 * gl_FragCoord.y / resolution.y) ;

 	// Compute the angle between the current pos and the axis of reference (direction)
	float cosAngle = dot( coord, direction );
	float angle    = acos(cosAngle) / TWO_PI;

    float red   = 0.0;
    float green = 0.0;
    float blue  = 0.0;

    float curve = smoother(angle);

 	float distance = length(coord) / getFlare(angle, 0.0);

    float circle = smoothstep( 0.51, 0.52, 1.0 - distance );

 	gl_FragColor = vec4(angle, 0.0, 0.0, 1.0);

}