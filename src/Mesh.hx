package;

import kha.arrays.Float32Array;
import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;

class Mesh {
	private var _vertexBuffer:VertexBuffer;
	private var _indexBuffer:IndexBuffer;

	public function new() {}

	public function buildBuffers(vertices:Array<Float>, indices:Array<Int>, structure:VertexStructure) {
		// build our buffers
		_vertexBuffer = new VertexBuffer(
			Std.int(vertices.length / 3),
			structure,
			Usage.StaticUsage);
		var vbData:Float32Array = _vertexBuffer.lock();
		for(i in 0...vbData.length) {
			vbData.set(i, vertices[i]);
		}
		_vertexBuffer.unlock();

		_indexBuffer = new IndexBuffer(
			indices.length,
			Usage.StaticUsage);
		var iData:Array<Int> = _indexBuffer.lock();
		for(i in 0...iData.length) {
			iData[i] = indices[i];
		}
		_indexBuffer.unlock();
	}

	public function bindBuffers(g:Graphics) {
		g.setVertexBuffer(_vertexBuffer);
		g.setIndexBuffer(_indexBuffer);
	}
}