#version 100

#ifdef GL_ES
precision mediump float;
#endif

attribute vec3 pos;
attribute vec3 norm;

uniform mat4 MVP;

varying vec3 colour;

void kore() {
	colour = norm;
	gl_Position = MVP * vec4(pos, 1.0);
}