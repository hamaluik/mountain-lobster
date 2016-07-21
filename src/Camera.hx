package;

import kha.math.FastMatrix4;
import kha.math.FastVector3;

enum ProjectionMode {
	Orthographic(size:Float);
	Perspective(fieldOfView:Float);
}

class Camera {
	private var _p:FastMatrix4;
	private var _pDirty:Bool = true;
	public var P(get, never):FastMatrix4;
	public function get_P():FastMatrix4 {
		if(_pDirty) {
			_p = switch(Projection) {
				case ProjectionMode.Perspective(fov): FastMatrix4.perspectiveProjection(fov, Aspect, Near, Far);
				case ProjectionMode.Orthographic(halfY): {
					var halfX:Float = Aspect * halfY;
					FastMatrix4.orthogonalProjection(-halfX, halfX, -halfY, halfY, Near, Far);
				}
			}
			_pDirty = false;
		}
		return _p;
	}

	public var transform:Transform = new Transform();
	private var _v:FastMatrix4;
	private var _vDirty:Bool = true;
	public var V(get, never):FastMatrix4;
	public function get_V():FastMatrix4 {
		if(_vDirty) {
			_v = transform.M.inverse();
			//_v = FastMatrix4.lookAt(new FastVector3(0, -3, 0), new FastVector3(0, 0, 0), new FastVector3(0, 0, 1));
			_vDirty = false;
		}
		return _v;
	}

	private var _vp:FastMatrix4;
	public var VP(get, never):FastMatrix4;
	private var _vpDirty:Bool = true;
	public function get_VP() {
		if(_vpDirty) {
			_vp = FastMatrix4.identity().multmat(P);
			_vp = _vp.multmat(V);
			_vpDirty = false;
		}
		return _vp;
	}

	public var Near(default, set):Float = 0.1;
	public function set_Near(n:Float):Float {
		_pDirty = true;
		return Near = n;
	}
	public var Far(default, set):Float = 100;
	public function set_Far(f:Float):Float {
		_pDirty = true;
		return Far = f;
	}

	public var Aspect(default, set):Float = 4/3;
	public function set_Aspect(a:Float):Float {
		_pDirty = true;
		return Aspect = a;
	}

	public var Projection(default, set):ProjectionMode = ProjectionMode.Perspective(60);
	public function set_Projection(p:ProjectionMode):ProjectionMode {
		_pDirty = true;
		return Projection = p;
	}

	public function new(projection:ProjectionMode, near:Float, far:Float, aspect:Float) {
		Projection = projection;
		Near = near;
		Far = far;
		Aspect = aspect;
	}
}