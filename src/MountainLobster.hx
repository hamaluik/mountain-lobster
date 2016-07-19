package;

import kha.arrays.Float32Array;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Usage;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
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

	var mvp:FastMatrix4;
	var mvpID:ConstantLocation;

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

		// set up our camera
		mvpID = pipeline.getConstantLocation("MVP");
		var p = FastMatrix4.perspectiveProjection(45, 4/3, 0.1, 100);
		var v = FastMatrix4.lookAt(
			new FastVector3(4, 3, 3),
			new FastVector3(0, 0, 0),
			new FastVector3(0, 1, 0));
		var m = FastMatrix4.identity();

		mvp = FastMatrix4.identity();
		mvp = mvp.multmat(p);
		mvp = mvp.multmat(v);
		mvp = mvp.multmat(m);

		trace(mvpID);
		trace(mvp);

		// set up rendering and updates
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	function update():Void {}

	function render(frame:Framebuffer):Void {
		var g = frame.g4;
		g.begin();
		g.clear(Color.fromFloats(0.25, 0.25, 0.25));

		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);

		g.setPipeline(pipeline);

		//g.setMatrix(mvpID, mvp);
		g.setMatrix(mvpID, mvp);

		g.drawIndexedVertices();

		g.end();
	}
}