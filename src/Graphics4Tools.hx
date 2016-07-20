package;

import kha.graphics4.Graphics;

class Graphics4Tools {
	public static function useMaterial(g:Graphics, m:Material) {
		if(m == null) return;
		m.setup(g);
	}

	public static function drawMesh(g:Graphics, m:Mesh) {
		if(m == null) return;
		m.bindBuffers(g);
		g.drawIndexedVertices();
	}
}