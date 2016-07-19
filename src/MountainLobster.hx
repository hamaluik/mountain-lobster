package;

import kha.arrays.Float32Array;
import kha.graphics4.Usage;
import kha.Shaders;
import kha.Framebuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Scheduler;
import kha.System;
import kha.Color;

class MountainLobster {
	static var vertices:Array<Float> = [
		-1, -1, 0,
		1, -1, 0,
		0, 1, 0
	];
	static var indices:Array<Int> = [0, 1, 2];

	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;

	public function new() {
		// define the vertex structure
		var structure:VertexStructure = new VertexStructure();
		structure.add("pos", VertexData.Float3);

		// compile the pipeline
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.fragmentShader = Shaders.simple_frag;
		pipeline.compile();

		// build our buffers
		vertexBuffer = new VertexBuffer(
			Std.int(vertices.length / 3),
			structure,
			Usage.StaticUsage);
		var vbData:Float32Array = vertexBuffer.lock();
		for(i in 0...vbData.length) {
			vbData.set(i, vertices[i]);
		}
		vertexBuffer.unlock();

		indexBuffer = new IndexBuffer(indices.length, Usage.StaticUsage);
		var iData:Array<Int> = indexBuffer.lock();
		for(i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();

		// set up rendering and updates
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	function update():Void {}

	function render(frame:Framebuffer):Void {
		var g = frame.g4;
		g.begin();
		g.clear(Color.Black);

		g.setPipeline(pipeline);
		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);

		g.drawIndexedVertices();

		g.end();
	}
}