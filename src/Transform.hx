package;

import kha.math.FastMatrix4;
import kha.math.FastVector3;
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
}