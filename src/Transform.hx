package;

import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.math.FastVector4;
import kha.math.Quaternion;

class Transform {
	public var Parent:Transform = null;
	public var LocalPosition:FastVector3 = new FastVector3(0, 0, 0);
	public var LocalRotation:Quaternion = new Quaternion(0, 0, 0, 1);
	public var LocalScale:FastVector3 = new FastVector3(1, 1, 1);

	// todo: implement caching
	public var M(get, never):FastMatrix4;
	public function get_M():FastMatrix4 {
		var translation:FastMatrix4 = FastMatrix4.translation(LocalPosition.x, LocalPosition.y, LocalPosition.z);
		var rotation:FastMatrix4 = FastMatrix4.fromMatrix4(LocalRotation.matrix());
		var scale:FastMatrix4 = FastMatrix4.scale(LocalScale.x, LocalScale.y, LocalScale.z);
		var m:FastMatrix4 = translation.multmat(rotation).multmat(scale);
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
		var r:FastMatrix4 = new FastMatrix4(
			m._00 / sx, m._10 / sy, m._10 / sz, 0,
			m._01 / sx, m._11 / sy, m._21 / sz, 0,
			m._02 / sx, m._12 / sy, m._22 / sz, 0,
			0, 0, 0, 1
		);

		// adapted from http://www.cg.info.hiroshima-cu.ac.jp/~miyazaki/knowledge/teche52.html
		function sign(x:Float):Float return x >= 0 ? 1.0 : -1.0;
		function norm(a:Float, b:Float, c:Float, d:Float):Float return Math.sqrt(a * a + b * b + c * c + d * d);

		var q0:Float = ( r._11 + r._22 + r._33 + 1) / 4;
		var q1:Float = ( r._11 - r._22 - r._33 + 1) / 4;
		var q2:Float = (-r._11 + r._22 - r._33 + 1) / 4;
		var q3:Float = (-r._11 - r._22 + r._33 + 1) / 4;

		if(q0 < 0) q0 = 0;
		if(q1 < 0) q1 = 0;
		if(q2 < 0) q2 = 0;
		if(q3 < 0) q3 = 0;

		q0 = Math.sqrt(q0);
		q1 = Math.sqrt(q1);
		q2 = Math.sqrt(q2);
		q3 = Math.sqrt(q3);

		if(q0 >= q1 && q0 >= q2 && q0 >= q3) {
			q0 *= 1;
			q1 *= sign(r._32 - r._23);
			q2 *= sign(r._13 - r._31);
			q3 *= sign(r._21 - r._12);
		} else if(q1 >= q0 && q1 >= q2 && q1 >= q3) {
			q0 *= sign(r._32 - r._23);
			q1 *= 1;
			q2 *= sign(r._21 + r._12);
			q3 *= sign(r._13 + r._31);
		} else if(q2 >= q0 && q2 >= q1 && q2 >= q3) {
			q0 *= sign(r._13 - r._31);
			q1 *= sign(r._21 + r._12);
			q2 *= 1;
			q3 *= sign(r._32 + r._23);
		} else if(q3 >= q0 && q3 >= q1 && q3 >= q2) {
			q0 *= sign(r._21 - r._12);
			q1 *= sign(r._31 + r._13);
			q2 *= sign(r._32 + r._23);
			q3 *= 1;
		} else {
			throw 'Unknown error converting rotation matrix to quaternion!';
		}

		var q:FastVector4 = new FastVector4(q1, q2, q3, q0);
		q.normalize();
		t.LocalRotation = new Quaternion(q.x, q.y, q.z, q.w);

		return t;
	}
}