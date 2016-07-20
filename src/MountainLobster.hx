package;

import kha.Assets;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Usage;
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
	var structures:Array<VertexStructure>;
	var material:Material;
	var camera:Camera;
	var transform:Transform;
	var mesh:Mesh;

	public function new() {
		// load our scene
		Assets.loadBlob("scene_ogex", function(blob:kha.Blob) {
			var data:loaders.OgexData = new loaders.OgexData(blob.toString());
			var go:loaders.OgexData.GeometryObject = data.geometryObjects[0];

			trace(data.getNode("Sun"));

			mesh = new Mesh();
			mesh.VertexData.push(
				new VertexDataDescription("position", go.mesh.getArray("position").values)
					.addStructure("pos", VertexData.Float3)
					.setUsage(Usage.StaticUsage));
			mesh.VertexData.push(
				new VertexDataDescription("normal", go.mesh.getArray("normal").values)
					.addStructure("norm", VertexData.Float3)
					.setUsage(Usage.StaticUsage));
			mesh.IndexData = go.mesh.indexArray.values;
			mesh.buildBuffers();

			// build our material
			material = new Material("unlit_colour", mesh.getStructures(), Shaders.diffuse_vert, Shaders.diffuse_frag);
			material.setUniform("lightPos", Float3(0, 2, 2));
			material.setUniform("MVP", Mat4(transform.MVP(camera.VP)));
			material.setUniform("P", Mat4(camera.P));
			material.setUniform("V", Mat4(camera.V));
			material.setUniform("VP", Mat4(camera.VP));

			trace('Mesh loaded!');
		});

		// set up our camera
		camera = new Camera(Camera.ProjectionMode.Perspective(60), 0.1, 100, 16/9);

		// set up our object
		transform = new Transform();

		// set up rendering and updates
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	private var angle:Float = 0;

	function update():Void {
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