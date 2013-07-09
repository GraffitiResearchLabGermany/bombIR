
// Mirror

#ifdef GL_ES
precision highp float;
#endif

// The video image will be displayed as a texture, therefore, we need a texture shader
#define PROCESSING_TEXTURE_SHADER

// Texture shaders require these standard uniforms. The filter() function in the sketch 
// will pass everything that has been drawn on the screen via the 'texture' uniform. 
uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;


void main(void)
{
	vec2 coord = vertTexCoord.st;

    // Mirror the image horizontally
    coord.x = 1.0 - coord.x; 

    // Get the color of the pixel at our fragment's coordinates
    vec4 pixel = texture2D( texture, coord );
	
	gl_FragColor= vec4(pixel.r, pixel.g, pixel.b, 1.0);
}