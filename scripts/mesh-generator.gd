class_name MeshGen

static func create_fancy_outline_arrow_mesh() -> ArrayMesh:
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var vertices = PackedVector2Array()
	var colors = PackedColorArray()
	var indices = PackedInt32Array()
	
	# Inner arrow (filled)
	var inner_scale = 0.8
	vertices.append(Vector2(0, -20))
	vertices.append(Vector2(-6 * inner_scale, 0))
	vertices.append(Vector2(-2 * inner_scale, 0))
	vertices.append(Vector2(-2 * inner_scale, 8))
	vertices.append(Vector2(2 * inner_scale, 8))
	vertices.append(Vector2(2 * inner_scale, 0))
	vertices.append(Vector2(6 * inner_scale, 0))
	
	for i in range(7):
		colors.append(Color.WHITE)
	
	# Triangulate the arrow
	indices.append_array([0, 1, 2])  # Left side of head
	indices.append_array([0, 2, 5])  # Right side and body
	indices.append_array([0, 5, 6])  # Right side of head
	indices.append_array([2, 3, 4])  # Body
	indices.append_array([2, 4, 5])  # Body
	
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	return mesh
