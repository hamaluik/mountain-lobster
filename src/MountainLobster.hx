package;

import kha.Assets;
import kha.graphics4.ConstantLocation;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.math.Quaternion;
import kha.math.Vector3;
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

using Graphics4Tools;

class MountainLobster {
	var structure:VertexStructure;
	var material:Material;
	var camera:Camera;
	var transform:Transform;
	var mesh:Mesh;

	public function new() {
		// set up the vertex structure
		structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);

		// load our scene
		Assets.loadBlob("scene_ogex", function(blob:kha.Blob) {
			var data:loaders.OgexData = new loaders.OgexData(blob.toString());
			var go:loaders.OgexData.GeometryObject = data.geometryObjects[0];
			var vertices:Array<Float> = go.mesh.getArray("position").values;
			var indices:Array<Int> = go.mesh.indexArray.values;

			mesh = new Mesh();
			mesh.buildBuffers(vertices, indices, structure);
		});

		// build our material
		material = new Material("unlit_colour", [structure], Shaders.simple_vert, Shaders.simple_frag);

		// set up our camera
		camera = new Camera(Camera.ProjectionMode.Perspective(60), 0.1, 100, 16/9);

		// set up our object
		transform = new Transform();

		// calculate our MVP
		material.setUniform("MVP", Mat4(transform.MVP(camera.VP)));

		// set up rendering and updates
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	private var angle:Float = 0;

	function update():Void {
		transform.LocalRotation = Quaternion.fromAxisAngle(new Vector3(0, 0, 1), -angle * 3);
		angle += 0.01;
		material.setUniform("MVP", Mat4(transform.MVP(camera.VP)));
	}

	function render(frame:Framebuffer):Void {
		var g = frame.g4;
		g.begin();
		g.clear(Color.fromFloats(0.25, 0.25, 0.25));

		g.useMaterial(material);
		g.drawMesh(mesh);

		g.end();
	}
}