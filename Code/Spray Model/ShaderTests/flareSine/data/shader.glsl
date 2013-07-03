#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

uniform vec2 iResolution;
uniform float iGlobalTime;

// not implemented yet
uniform float iChannelTime[4]; 
uniform vec4 iMouse;
uniform vec4 iDate;

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


// -------- Compatible Shadertoy code ---------------------

#define TWO_PI 6.2831853071795865


void main(void)
{
	float scaleX = iResolution.x;// horizontal scaling factor
	float scaleY = iResolution.y;// vertical scaling factor
	
	float animation = sin(radians(iGlobalTime * 50.0));
	
	// Gamma correction
	float gA = scaleY * animation; // proportionnality constant
	float gC = scaleX; // horizontal scale of the gamma
	float gamma = 0.5; // Gamma value
	float gCenter = scaleY/2.0 - animation * scaleY/2.0; // vertical offset
	
    float g = (gA * pow(gl_FragCoord.x * gC, gamma) / scaleX + gCenter) / scaleY ;
	
	// Target function
	float A = (scaleY / 2.0); // Amplitude
	float p = scaleX; // period
	float t = gl_FragCoord.x + (g * scaleY); // time
	float d = 0.0; //shift 
    float B = scaleY / 2.0; // center
	float range = TWO_PI * g;
	
	float y = A * sin( (range / p) * (d - t) ) + B;
	
	float sineColor = smoothstep(y+1.0, y-1.0, gl_FragCoord.y);
	float gammaColor = smoothstep(g*scaleY+1.0, g*scaleY-1.0, gl_FragCoord.y);
	
	gl_FragColor = vec4(sineColor, 0.0, gammaColor, 1.0);
}