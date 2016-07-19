attribute vec3 pos;

void kore() {
	// Just output position
	gl_Position = vec4(pos, 1.0);
}