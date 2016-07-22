package;

import kha.Assets;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Usage;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.math.FastVector4;
import kha.math.Quaternion;
import kha.math.Vector3;
import kha.Shaders;
import kha.Framebuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Color;
import zui.Id;
import zui.Zui;

using Graphics4Tools;

class MountainLobster {
	var initialized:Bool = false;

	var structures:Array<VertexStructure>;
	var material:Material;
	var camera:Camera;
	var transform:Transform;
	var mesh:Mesh;

	var ui:Zui;

	public function new() {
		Assets.loadEverything(loadingFinished);
	}

	function loadingFinished() {
		var data:loaders.OgexData = new loaders.OgexData(Assets.blobs.scene_ogex.toString());
		var go:loaders.OgexData.GeometryObject = data.geometryObjects[0];

		// set up our light
		var lT:Array<Float> = data.getNode("Sun").transform.values;
		var sunTransform = Transform.fromLocalMat4(new FastMatrix4(
			lT[0], lT[1], lT[2], lT[3],
			lT[4], lT[5], lT[6], lT[7],
			lT[8], lT[9], lT[10], lT[11],
			lT[12], lT[13], lT[14], lT[15]));
		var sunDir:FastVector4 = sunTransform.M.multvec(new FastVector4(0, 0, 1, 0));

		// set up our camera
		var cT:Array<Float> = data.getNode("Camera").transform.values;
		var cameraTransform = Transform.fromLocalMat4(new FastMatrix4(
			cT[0], cT[1], cT[2], cT[3],
			cT[4], cT[5], cT[6], cT[7],
			cT[8], cT[9], cT[10], cT[11],
			cT[12], cT[13], cT[14], cT[15]));
		var camObj:loaders.OgexData.CameraObject = data.getCameraObject(data.getNode("Camera").objectRefs[0]);
		var fov:Float = 60, near:Float = 0.1, far:Float = 100;
		for(param in camObj.params) {
			switch(param.attrib) {
				case 'fov': fov = param.value * 180 / Math.PI;
				case 'near': near = param.value;
				case 'far': far = param.value;
			}
		}
		camera = new Camera(Camera.ProjectionMode.Perspective(fov/2), near, far, 16/9);
		camera.transform = cameraTransform;

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
		material.setUniform("sunDir", Float3(sunDir.x, sunDir.y, sunDir.z));

		// load  our transform
		var sT:Array<Float> = data.getNode("Suzanne").transform.values;
		transform = Transform.fromLocalMat4(new FastMatrix4(
			sT[0], sT[1], sT[2], sT[3],
			sT[4], sT[5], sT[6], sT[7],
			sT[8], sT[9], sT[10], sT[11],
			sT[12], sT[13], sT[14], sT[15]));

		// load our UI
		ui = new Zui(Assets.fonts.DroidSans, 20, 14, 0, 1.5);

		// ready to rock!
		initialized = true;
	}

	private var rotation:Float = 0;

	public function update():Void {
		if(!initialized) return;

		// apply object rotation
		transform.LocalRotation = FastMatrix4.rotationZ(rotation * Math.PI / 180);

		// camera setup
		material.setUniform("MVP", Mat4(transform.MVP(camera.VP)));
		material.setUniform("VP", Mat4(camera.VP));
		material.setUniform("M", Mat4(transform.M));
		material.setUniform("V", Mat4(camera.V));
		material.setUniform("P", Mat4(camera.P));
	}

	public function render(frame:Framebuffer):Void {
		if(!initialized) return;

		var g = frame.g4;
		g.begin();
		g.clear(Color.fromFloats(0.25, 0.25, 0.25));

		g.useMaterial(material);
		g.drawMesh(mesh);

		g.end();

		ui.begin(frame.g2);
			if(ui.window(Id.window(), 10, 10, 100, 100)) {
				rotation = ui.slider(Id.slider(), "Rotation", 0, 360, false, 1, rotation);
			}
		ui.end();
	}
}