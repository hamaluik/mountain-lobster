#version 100

#ifdef GL_ES
precision mediump float;
#endif

attribute vec3 pos;
attribute vec3 norm;

uniform vec3 sunDir;
uniform mat4 MVP;
uniform mat4 VP;
uniform mat4 M;
uniform mat4 V;
uniform mat4 P;

varying vec3 colour;

const vec3 materialDiffuse = vec3(0.8, 0.8, 0.8);
const vec3 sunColour = vec3(1.0, 1.0, 1.0);

void kore() {
	// transform normals into world space
	vec3 worldNorm = (M * vec4(norm, 0.0)).xyz;
	float dSun = clamp(dot(worldNorm, sunDir), 0.0, 1.0);
	
	colour = (materialDiffuse * sunColour * dSun) + (materialDiffuse * 0.2);
	gl_Position = MVP * vec4(pos, 1.0);
}