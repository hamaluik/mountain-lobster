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

using Material;

class MountainLobster {
	static var vertices:Array<Float> = [
		-1, -1, 0,
		1, -1, 0,
		0, 1, 0
	];
	static var indices:Array<Int> = [0, 1, 2];

	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;

	var material:Material;
	var camera:Camera;

	var mvp:FastMatrix4;

	public function new() {
		// define the vertex structure
		var structure:VertexStructure = new VertexStructure();
		structure.add("pos", VertexData.Float3);

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

		// build our material
		material = new Material("unlit_colour", [structure], Shaders.simple_vert, Shaders.simple_frag);

		// set up our camera
		camera = new Camera(Camera.ProjectionMode.Perspective(60), 0.1, 100, 4/3);
		var m = FastMatrix4.identity();

		mvp = FastMatrix4.identity();
		mvp = mvp.multmat(camera.VP);
		mvp = mvp.multmat(m);

		material.setUniform("MVP", Mat4(mvp));
		material.setUniform("derp", Bool(false));

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

		g.use(material);

		g.drawIndexedVertices();

		g.end();
	}
}