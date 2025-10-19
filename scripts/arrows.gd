extends Node2D

@export var multi_mesh_instance: MultiMeshInstance2D

## Arrow Grid settings
@export_category("Grid")
@export var grid_size: Vector2 = Vector2i(20.0, 15.0)
@export var spacing: float = 50.0

## Size setting
@export_category("Arrow Size")
@export var base_size: float = 1.0
@export var max_size: float = 3.0
@export var min_size: float = 0.3
@export var max_distance: float = 500.0

## Arrow design
@export_category("Arrow Design") 
@export var arrow_length: float = 20.0
@export var arrow_width: float = 10.0
@export var head_length: float = 8.0
@export var head_width: float = 15.0

@export var update_radius: float = 800.0:
	set(value):
		update_radius = value
		update_radius_sq = update_radius * update_radius

var arrow_positions: PackedVector2Array = PackedVector2Array()

var update_radius_sq: float = 800.0 * 800.0
var last_mouse_pos: Vector2 = Vector2.ZERO


func _ready() -> void:
	if grid_size == -Vector2.ONE:
		grid_size = get_viewport_rect().size / spacing
	initialize_arrow_positions()
	setup_multi_mesh()

func setup_multi_mesh() -> void:
	var multi_mesh: MultiMesh = MultiMesh.new()
	multi_mesh.transform_format = MultiMesh.TRANSFORM_2D
	multi_mesh.use_colors = true
	multi_mesh.instance_count = int(grid_size.x * grid_size.y)

	var mesh: ArrayMesh = MeshGen.create_fancy_outline_arrow_mesh()
	multi_mesh.mesh = mesh

	multi_mesh_instance.multimesh = multi_mesh
	update_arrows(get_global_mouse_position(), false)

func initialize_arrow_positions() -> void:
	arrow_positions = PackedVector2Array()
	arrow_positions.resize(int(grid_size.x * grid_size.y))
	var index: int = 0
	var start_x: float = spacing * 0.5
	var start_y: float = spacing * 0.5
	for y: int in range(grid_size.y):
		for x: int in range(grid_size.x):
			var arrow_pos: Vector2 = Vector2(
				start_x + x * spacing,
				start_y + y * spacing,
			)
			arrow_positions[index] = arrow_pos
			index += 1


func update_arrows(mouse_pos: Vector2, optimized: bool = true) -> void:
	var multi_mesh: MultiMesh = multi_mesh_instance.multimesh
	var index: int = 0

	for y: int in range(grid_size.y):
		for x: int in range(grid_size.x):

			var direction: Vector2 = mouse_pos - arrow_positions[index]

			if direction.length_squared() >= update_radius_sq and optimized:
				index += 1
				continue

			var distance: float = direction.length()
			var angle: float = direction.angle() + PI * 0.5
			var scale_factor: float = calculate_scale(distance)

			var arrow_transform: Transform2D = Transform2D()
			arrow_transform = arrow_transform.rotated(angle)
			arrow_transform = arrow_transform.scaled(Vector2(scale_factor, scale_factor))
			arrow_transform.origin = arrow_positions[index]

			multi_mesh.set_instance_transform_2d(index, arrow_transform)
			multi_mesh.set_instance_color(index, calculate_color(distance))

			index += 1


func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()

	# 25 -> mouse movement threshold squared
	if mouse_pos.distance_squared_to(last_mouse_pos) < 25.0:
		return
	
	last_mouse_pos = mouse_pos
	update_arrows(mouse_pos)

# === Helper ===

func set_update_radius(new_update_radius: float) -> void:
	update_radius = new_update_radius
	update_radius_sq = update_radius * update_radius

func calculate_scale(distance: float) -> float:
	var normalized_distance: float = clamp(distance / max_distance, 0.0, 1.0)
	return lerp(max_size, min_size, normalized_distance)

func calculate_color(distance: float) -> Color:
	var normalized_distance: float = 1 - clamp(distance / max_distance, 0.0, 1.0)
	return ColorMan.get_heat_color(normalized_distance)
