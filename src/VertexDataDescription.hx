package;

import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;

class VertexDataDescription {
	public var Name:String;
	public var Data:Array<Float>;
	public var Structure:VertexStructure;
	public var Usage:kha.graphics4.Usage;

	public function new(name:String, data:Array<Float>) {
		Name = name;
		Data = data;
		Structure = new VertexStructure();
		Usage = kha.graphics4.Usage.StaticUsage;
	}

	public function addStructure(name:String, type:VertexData):VertexDataDescription {
		Structure.add(name, type);
		return this;
	}

	public function setUsage(usage:kha.graphics4.Usage):VertexDataDescription {
		Usage = usage;
		return this;
	}
}