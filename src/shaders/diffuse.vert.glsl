#version 100

#ifdef GL_ES
precision mediump float;
#endif

attribute vec3 pos;
attribute vec3 norm;

uniform vec3 sunDir;
uniform mat4 M;
uniform mat4 V;
uniform mat4 P;

varying vec3 colour;

const vec3 materialDiffuse = vec3(0.8, 0.8, 0.8);
const vec3 lightColour = vec3(0.8, 0.8, 0.8);

void kore() {
	float dSun = clamp(dot(norm, (V * vec4(sunDir, 0.0)).xyz), 0.0, 1.0);
	
	colour = (materialDiffuse * lightColour * dSun) + (materialDiffuse * 0.2);
	gl_Position = (P * V * M) * vec4(pos, 1.0);
}