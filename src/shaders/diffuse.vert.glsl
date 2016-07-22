#ifdef GL_ES
precision mediump float;
#endif

// inputs
attribute vec3 pos;
attribute vec3 norm;

// light uniforms
uniform vec3 sunDir;
uniform vec3 sunColour;
uniform vec3 ambientColour;

// material uniforms
uniform vec3 diffuseColour;

// camera uniforms
uniform mat4 MVP;
uniform mat4 VP;
uniform mat4 M;
uniform mat4 V;
uniform mat4 P;

// outputs
varying vec3 colour;

void kore() {
	// set the camera-space position of the vertex
	gl_Position = MVP * vec4(pos, 1.0);

	// transform normals into world space
	vec3 worldNorm = (M * vec4(norm, 0.0)).xyz;

	// sun diffuse term
	float dSun = clamp(dot(worldNorm, sunDir), 0.0, 1.0);
	
	// calculate the diffuse colour
	colour  = diffuseColour * sunColour * dSun;
	// add in ambience
	colour += diffuseColour * ambientColour;
}