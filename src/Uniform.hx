package;

import haxe.ds.Vector;
import kha.Color;
import kha.FastFloat;
import kha.graphics4.ConstantLocation;
import kha.math.FastMatrix4;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.FastVector4;

enum TUniform {
	Bool(x:Bool);
	Int(x:Int);
	Float(x:FastFloat);
	Float2(x:FastFloat, y:FastFloat);
	Float3(x:FastFloat, y:FastFloat, z:FastFloat);
	Float4(x:FastFloat, y:FastFloat, z:FastFloat, w:FastFloat);
	Floats(x:Vector<FastFloat>);
	Vec2(x:FastVector2);
	Vec3(x:FastVector3);
	Vec4(x:FastVector4);
	Mat4(v:FastMatrix4);
	RGB(c:Color);
	RGBA(c:Color);
}

class Uniform {
	public var Value:TUniform;
	public var Location:ConstantLocation;

	public function new() {}
}