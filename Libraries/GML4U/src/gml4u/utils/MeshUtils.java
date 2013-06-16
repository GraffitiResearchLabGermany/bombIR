package gml4u.utils;

import gml4u.model.GmlPoint;

import java.util.List;

import toxi.geom.Vec3D;
import toxi.geom.mesh.TriangleMesh;

public class MeshUtils {
	
	/**
	 * Updates the given mesh using the points list
	 * @param mesh - TriangleMesh
	 * @param points - List<GmlPoint>
	 */
	public static void updateMesh(TriangleMesh mesh, List<GmlPoint> points) {

		mesh.clear();

		GmlPoint prev = new GmlPoint();
		GmlPoint pos = new GmlPoint();
		Vec3D a = new Vec3D();
		Vec3D b = new Vec3D();
		Vec3D p=new Vec3D();
		Vec3D q=new Vec3D();
		float weight = 0;

		for (GmlPoint point: points) {
			if (prev.isZeroVector()) {
				prev.set(point);
			}
			pos.set(point);
			// use distance to previous point as target stroke weight
			weight += (Math.sqrt(pos.distanceTo(prev))*2-weight)*0.1;

			/*weight = 0;
			if(pos.time- prev.time != 0) {
				weight = pos.distanceTo(prev);
			}*/

			// TODO set an upper limit to weight

			// define offset points for the triangle strip
			a.set(pos);
			b.set(pos);
			a.addSelf(0, 0, weight);
			b.addSelf(0, 0, -weight);

			// add 2 faces to the mesh
			mesh.addFace(p,b,q);
			mesh.addFace(p,a,b);

			// store current points for next iteration
			prev.set(pos);
			p.set(a);
			q.set(b);
		}	
	}
}