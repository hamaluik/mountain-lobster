package;

import haxe.ds.StringMap;
import kha.arrays.Float32Array;
import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;

using Lambda;

class Mesh {
	private var _vertexBuffers:Array<VertexBuffer>;
	private var _indexBuffer:IndexBuffer;

	public function new() {}

	public var VertexData:Array<VertexDataDescription> = new Array<VertexDataDescription>();
	public var IndexData:Array<Int> = new Array<Int>();

	public function getStructures():Array<VertexStructure> {
		return VertexData.map(function(d:VertexDataDescription):VertexStructure {
			return d.Structure;
		});
	}

	public function buildBuffers() {
		// build our array of vertex buffers
		_vertexBuffers = new Array<VertexBuffer>();
		for(data in VertexData) {
			// instantiate the buffer
			var buffer:VertexBuffer = new VertexBuffer(
				data.Data.length,
				data.Structure,
				data.Usage);

			// copy the data
			var vbData:Float32Array = buffer.lock();
			for(i in 0...vbData.length) {
				vbData.set(i, data.Data[i]);
			}
			buffer.unlock();

			// store it for later
			_vertexBuffers.push(buffer);
		}

		// build the triangle index buffer
		_indexBuffer = new IndexBuffer(
			IndexData.length,
			kha.graphics4.Usage.StaticUsage); // TODO: make changeable
		var iData:Array<Int> = _indexBuffer.lock();
		for(i in 0...iData.length) {
			iData[i] = IndexData[i];
		}
		_indexBuffer.unlock();
	}

	public function bindBuffers(g:Graphics) {
		g.setVertexBuffers(_vertexBuffers);
		g.setIndexBuffer(_indexBuffer);
	}
}