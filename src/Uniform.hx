package;

import glm.Mat3;
import glm.Mat4;
import glm.Quat;
import glm.Vec2;
import glm.Vec3;
import glm.Vec4;
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
	Vector2(x:FastVector2);
	Vector3(x:FastVector3);
	Vector4(x:FastVector4);
	Matrix4(v:FastMatrix4);
	Vec2(x:Vec2);
	Vec3(x:Vec3);
	Vec4(x:Vec4);
	Mat3(v:Mat3);
	Mat4(v:Mat4);
	Quat(q:Quat);
	RGB(c:Color);
	RGBA(c:Color);
}

class Uniform {
	public var Value:TUniform;
	public var Location:ConstantLocation;

	public function new() {}
}