#version 100

#ifdef GL_ES
precision mediump float;
#endif

attribute vec3 pos;
attribute vec3 norm;

uniform vec3 lightPos;
uniform mat4 MVP;
uniform mat4 V;
uniform mat4 P;

varying vec3 colour;

const vec3 materialDiffuse = vec3(0.8, 0.8, 0.8);
const vec3 lightColour = vec3(0.8, 0.8, 0.8);

void kore() {
	vec3 dir = normalize(lightPos - pos);
	float d = clamp(dot(norm, dir), 0.0, 1.0);
	
	colour = (materialDiffuse * lightColour * d) + (materialDiffuse * 0.2);
	gl_Position = MVP * vec4(pos, 1.0);
}