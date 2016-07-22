package;

import glm.Mat3;
import glm.Vec2;
import glm.Vec3;
import glm.Vec4;
import glm.Mat3;
import glm.Mat4;
import kha.graphics4.Graphics;
import kha.SystemImpl;

#if js
import kha.js.graphics4.ConstantLocation;
#else
// NOTE: non-JS targets aren't supported here yet!
asdsadsadfas
#end

class GLMTools {
	public static function setVec2(g:Graphics, l:kha.graphics4.ConstantLocation, v:Vec2) {
		SystemImpl.gl.uniform2f(cast(l, ConstantLocation).value, v.x, v.y);
	}

	public static function setVec3(g:Graphics, l:kha.graphics4.ConstantLocation, v:Vec3) {
		SystemImpl.gl.uniform3f(cast(l, ConstantLocation).value, v.x, v.y, v.z);
	}

	public static function setVec4(g:Graphics, l:kha.graphics4.ConstantLocation, v:Vec4) {
		SystemImpl.gl.uniform4f(cast(l, ConstantLocation).value, v.x, v.y, v.z, v.w);
	}

	public static function setMat3(g:Graphics, l:kha.graphics4.ConstantLocation, m:Mat3) {
		// TODO: less allocation!
		SystemImpl.gl.uniformMatrix3fv(cast(l, ConstantLocation).value, false, m.toArrayRowMajor());
	}

	public static function setMat4(g:Graphics, l:kha.graphics4.ConstantLocation, m:Mat4) {
		// TODO: less allocation!
		SystemImpl.gl.uniformMatrix4fv(cast(l, ConstantLocation).value, false, m.toArrayRowMajor());
	}
}