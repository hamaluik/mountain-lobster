package;

import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.math.FastVector4;
import kha.math.Quaternion;

class Transform {
	public var Parent:Transform = null;
	public var LocalPosition:FastVector3 = new FastVector3(0, 0, 0);
	public var LocalRotation:FastMatrix4 = FastMatrix4.rotation(0, 0, 0);
	public var LocalScale:FastVector3 = new FastVector3(1, 1, 1);

	// todo: implement caching
	public var M(get, never):FastMatrix4;
	public function get_M():FastMatrix4 {
		var translation:FastMatrix4 = FastMatrix4.translation(LocalPosition.x, LocalPosition.y, LocalPosition.z);
		var scale:FastMatrix4 = FastMatrix4.scale(LocalScale.x, LocalScale.y, LocalScale.z);
		var m:FastMatrix4 = translation.multmat(LocalRotation).multmat(scale);
		if(Parent != null) {
			m = FastMatrix4.identity().multmat(Parent.M).multmat(m);
		}
		return m;
	}

	public function new() {}

	public function MVP(VP:FastMatrix4):FastMatrix4 {
		return FastMatrix4.identity().multmat(VP).multmat(M);
	}

	public static function fromLocalMat4(m:FastMatrix4):Transform {
		// adapted from http://math.stackexchange.com/a/1463487
		var t:Transform = new Transform();

		// translation
		t.LocalPosition.x = m._30;
		t.LocalPosition.y = m._31;
		t.LocalPosition.z = m._32;

		// scale
		var sx:Float = new FastVector3(m._00, m._01, m._02).length;
		var sy:Float = new FastVector3(m._10, m._11, m._12).length;
		var sz:Float = new FastVector3(m._20, m._21, m._22).length;
		t.LocalScale = new FastVector3(sx, sy, sz);

		// rotation
		t.LocalRotation = new FastMatrix4(
			m._00 / sx, m._10 / sy, m._20 / sz, 0,
			m._01 / sx, m._11 / sy, m._21 / sz, 0,
			m._02 / sx, m._12 / sy, m._22 / sz, 0,
			0, 0, 0, 1
		);

		return t;
	}
}