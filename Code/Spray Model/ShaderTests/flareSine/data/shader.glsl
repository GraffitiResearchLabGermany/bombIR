#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

uniform vec2 iResolution;      // viewport resolution (in pixels)
uniform float iGlobalTime;     // shader playback time (in seconds)
uniform vec4 iMouse;           // mouse pixel coords. xy: current (if MLB down), zw: click


// not implemented yet

uniform float iChannelTime[4]; // channel playback time (in seconds)
uniform vec4 iDate;            // (year, month, day, time in seconds)


// Channels can be either 2D maps or Cubemaps. Pick the ones you need.

/*
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

uniform samplerCube iChannel0;
uniform samplerCube iChannel1;
uniform samplerCube iChannel2;
uniform samplerCube iChannel3;
*/


// -------- Below is the code you can directly paste back and forth from www.shadertoy.com ---------

#define TWO_PI 6.2831853071795865
#define PI 3.1415926535897932384

// smoothing
float smoother(float y) {
	float s = 1.0 / iResolution.y;
	float shade = smoothstep( y+s, y-s, gl_FragCoord.y / iResolution.y );
	return shade;
}

void main(void)
{
	vec2 scale = iResolution.xy; // scaling factor

	vec2 pos = gl_FragCoord.xy / scale;
	
	float animate = sin(radians(iGlobalTime * 50.0)) / 2.0 + 0.5; // goes from 0.0 to 1.0
	
	// Power function
	float exp = 0.5;//animate * 1.2 + 0.5 ; // Exponent	
    float Pow = pow(pos.x, exp);

    // Linear function
    float Lin = pos.x;

    float Arc = acos( - pos.x * 2.0 + 1.0 ) / PI;

    // x = x^3
    float Pw3 = (pow( pos.x * 6.0 - 3.0, 3.0 ) + 27.0) / 54.0;

    // The envelope is the diff between the power and linear functions
    float Env = mix( Pw3, Lin, animate ) - Lin;
	
	// Target function
	float A = 0.5; // Amplitude
	float p = 1.0; // period
	float t = pos.x + Env; // time
	float d = 0.25; //shift 
    float B = 0.5; // center
	float range = TWO_PI;
	
	float Sin = A * sin( (range / p) * (d - t) ) + B;
	
	float sinColor = smoother(Sin);
	float linColor = smoother(Lin);
	float powColor = smoother(Pow);
	float arcColor = smoother(Arc);
	float testColor = smoother(Pw3);
	
	gl_FragColor = vec4(sinColor, testColor, linColor, 1.0);
}