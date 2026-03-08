@tool
extends CSGCombiner3D
class_name CaveGenerator

@export_tool_button("Generate!") var generate_button = generate_cave

@export_category("Cave Settings")
@export var size: int = 100
@export var room_amount: int = 20
@export var min_room_size: int = 1
@export var max_room_size: int = 5
@export var mesh_resolution: int = 5
@export var cave_material: StandardMaterial3D
@export var ore_scene: PackedScene = preload("res://scenes/ore.tscn")
@export var ore_amount: int = 10
@export var shop: ShopInteractable
@export var player: Player

var cave: Array
var connections: Array
var cave_connections: Array
var ore_scatter: Array

func generate_cave() -> void:
	if cave != []:
		delete_cave()
	
	for i in range(room_amount):
		var random_pos: Vector3 = Vector3(randi_range(-size, size), 1.5, randi_range(-size, size))
		if can_place(random_pos):
			var mesh: CSGMesh3D = CSGMesh3D.new()
			mesh.mesh = BoxMesh.new()
			mesh.scale = Vector3(randi_range(min_room_size, max_room_size), 3, randi_range(min_room_size, max_room_size))
			mesh.mesh.subdivide_width = mesh.scale.x / mesh_resolution
			mesh.mesh.subdivide_depth = mesh.scale.z / mesh_resolution
			mesh.mesh.subdivide_height = mesh.scale.y / mesh_resolution
			mesh.position = random_pos
			mesh.material = cave_material
			mesh.flip_faces = true
			
			add_child(mesh)
			cave.append(mesh)
			cave_connections.append(mesh)
	
	get_connecting_rooms()
	scatter_ores()
	set_locations()
func can_place(pos: Vector3) -> bool:
	if not cave:
		return true
	else:
		for c in cave:
			var dist = pos.distance_to(c.position)
			if dist < max_room_size:
				return false
		return true

func get_connecting_rooms() -> void:
	while cave_connections.size() > 2:
		var room1 = cave_connections[randi_range(0, cave_connections.size() - 1)]
		var room2 = cave_connections[randi_range(0, cave_connections.size() - 1)]
		while room1 == room2:
			room2 = cave_connections[randi_range(0, cave_connections.size() - 1)]
		
		connect_rooms(room1, room2)
		cave_connections.erase(room1)
	
	if cave_connections.size() == 2:
		var room1 = cave_connections[0]
		var room2 = cave_connections[1]
		connect_rooms(room1, room2)

func connect_rooms(room1: CSGMesh3D, room2: CSGMesh3D) -> void:
	var dir1 = room2.position.x - room1.position.x
	var dir2 = room2.position.z - room1.position.z
	
	var mesh1: CSGMesh3D = CSGMesh3D.new()
	mesh1.mesh = BoxMesh.new()
	mesh1.scale = Vector3(abs(dir1) + 3, 3, 3)
	mesh1.mesh.subdivide_width = mesh1.scale.x / mesh_resolution
	mesh1.mesh.subdivide_depth = mesh1.scale.z / mesh_resolution
	mesh1.mesh.subdivide_height = mesh1.scale.y / mesh_resolution
	mesh1.position = room1.position + Vector3(dir1 / 2, 0, 0)
	mesh1.material = cave_material
	mesh1.flip_faces = true
	
	add_child(mesh1)
	connections.append(mesh1)

	var mesh2: CSGMesh3D = CSGMesh3D.new()
	mesh2.mesh = BoxMesh.new()
	mesh2.scale = Vector3(3, 3, abs(dir2) + 3)
	mesh2.mesh.subdivide_width = mesh2.scale.x / mesh_resolution
	mesh2.mesh.subdivide_depth = mesh2.scale.z / mesh_resolution
	mesh2.mesh.subdivide_height = mesh2.scale.y / mesh_resolution
	mesh2.position = room2.position - Vector3(0, 0, dir2 / 2)
	mesh2.material = cave_material
	mesh2.flip_faces = true
	
	add_child(mesh2)
	connections.append(mesh2)

func scatter_ores() -> void:
	if ore_scatter != []:
			for i in ore_scatter:
				i.queue_free()
			ore_scatter.clear()
	
	for i in ore_amount:
		var ore = ore_scene.instantiate()
		var random_room = cave[randi_range(0, cave.size() - 1)]
		var random_pos = Vector3(
			randf_range(random_room.global_position.x - (random_room.scale.x / 2),
			random_room.global_position.x + (random_room.scale.x / 2)),
			0.0,
			randf_range(random_room.global_position.z - (random_room.scale.z / 2),
			random_room.global_position.z + (random_room.scale.z / 2))
		)
		
		ore.position = random_pos
		add_child(ore)
		ore_scatter.append(ore)

func set_locations() -> void:
	var room = cave_connections[randi_range(0, cave_connections.size() - 1)]
	var rand_pos = room.global_position
	player.global_position = Vector3(rand_pos.x, 0.0, rand_pos.z)
	shop.global_position = player.global_position

func delete_cave() -> void:
	for i in cave:
		i.queue_free()
	cave.clear()

	for i in cave_connections:
		i.queue_free()
	cave_connections.clear()

	for i in connections:
		i.queue_free()
	connections.clear()
	
	for i in ore_scatter:
		i.queue_free()
	ore_scatter.clear()
