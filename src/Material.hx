package;

import haxe.ds.StringMap;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;
import kha.graphics4.FragmentShader;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import Uniform.TUniform;

class Material {
	public var Name(default, null):String;
	public var Pipeline(default, null):PipelineState;
	public var Uniforms:StringMap<Uniform>;

	private var _bound:Bool = false;

	public function new(name:String, inputLayout:Array<VertexStructure>, vertexShader:VertexShader, fragmentShader:FragmentShader) {
		Name = name;

		Pipeline = new PipelineState();
		Pipeline.inputLayout = inputLayout;
		Pipeline.vertexShader = vertexShader;
		Pipeline.fragmentShader = fragmentShader;
		Pipeline.depthWrite = true;
		Pipeline.depthMode = CompareMode.Less;
		Pipeline.cullMode = CullMode.CounterClockwise;
		Pipeline.compile();

		Uniforms = new StringMap<Uniform>();
	}

	public function setUniform(name:String, value:Uniform.TUniform) {
		if(Uniforms.exists(name)) {
			var uniform:Uniform = Uniforms.get(name);
			uniform.Value = value;
		}
		else {
			var uniform:Uniform = new Uniform();
			uniform.Value = value;
			Uniforms.set(name, uniform);
			_bound = false;
		}
	}

	public function bindUniforms() {
		for(name in Uniforms.keys()) {
			Uniforms.get(name).Location = Pipeline.getConstantLocation(name);
		}
		_bound = true;
	}

	public function setup(g:Graphics) {
		if(!_bound) bindUniforms();
		g.setPipeline(Pipeline);

		for(uniform in Uniforms) {
			switch(uniform.Value) {
				case Bool(b): g.setBool(uniform.Location, b);
				case Int(i): g.setInt(uniform.Location, i);
				case Float(x): g.setFloat(uniform.Location, x);
				case Float2(x, y): g.setFloat2(uniform.Location, x, y);
				case Float3(x, y, z): g.setFloat3(uniform.Location, x, y, z);
				case Float4(x, y, z, w): g.setFloat4(uniform.Location, x, y, z, w);
				case Floats(x): g.setFloats(uniform.Location, x);
				case Vec2(x): g.setVector2(uniform.Location, x);
				case Vec3(x): g.setVector3(uniform.Location, x);
				case Vec4(x): g.setVector4(uniform.Location, x);
				case Mat4(m): g.setMatrix(uniform.Location, m);
				case RGB(c): g.setFloat3(uniform.Location, c.R, c.G, c.B);
				case RGBA(c): g.setFloat4(uniform.Location, c.R, c.G, c.B, c.A);
				case _: throw 'Unhandled uniform type ${uniform.Value}!';
			}
		}
	}

	public function toString() {
		return haxe.Json.stringify({
			name: Name,
			uniforms: Uniforms
		});
	}
}