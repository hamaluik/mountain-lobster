attribute vec3 pos;

uniform mat4 MVP;

void kore() {
	gl_Position = MVP * vec4(pos, 1.0);
}