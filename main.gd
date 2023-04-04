extends Node3D

@export var Camera : Node3D

const size = 1000
const max_chunk_size = 100
var map = []
var units = []

var CameraPosI : Vector2i
var prevCameraPosI : Vector2i

enum unit_type
{
	settler,
	soldier
}

enum tile_type
{
	PLAINS,
	FOREST,
	MOUNTAINS,
	DEEP_OCEAN,
	DESERT,
	OCEAN,
	TUNDRA,
	RIVER
}

const DARK_BLUE = Color("020552")
const RED = Color("ff0000")
const GREEN = Color("1b6b02")
const PALE_GREEN = Color("37f70c")
const WHITE = Color("ffffff")
const GREY = Color("474747")
const BLUE = Color("0052f5")
const BABY_BLUE = Color("42c4fc")
const YELLOW = Color("fced42")
const LIGHT_GREY = Color("b8b8b8")
const PALE_YELLOW = Color("fff8a6")

var settler_unit_instance := preload("res://unit.tscn").instantiate()
var soldier_unit_instance := preload("res://unit.tscn").instantiate()

func add_unit(a : int, global_coordinates : Vector2i):
	if a == unit_type.settler:
		var instance := settler_unit_instance.duplicate()
		instance.position.x = global_coordinates.x
		instance.position.z = global_coordinates.y
		units[global_coordinates.x][global_coordinates.y] = a
		$Units.add_child(instance)
	else: if a == unit_type.soldier:
		var instance := soldier_unit_instance.duplicate()
		instance.position.x = global_coordinates.x
		instance.position.z = global_coordinates.y
		units[global_coordinates.x][global_coordinates.y] = a
		$Units.add_child(instance)

func _init():
	for x in range(size):
		var y = []
		y.resize(size)
		map.append(y)
	for x in range(size):
		for y in range(size):
			map[x][y] = randi_range(0,tile_type.size()-1)
	for x in range(size):
		var y = []
		y.resize(size)
		units.append(y)

func _ready():
	print(tile_type.find_key(map[500][500]))
	$Tile_Collision/CollisionShape3D.shape.size.x = max_chunk_size
	$Tile_Collision/CollisionShape3D.shape.size.z = max_chunk_size
	$"Tile_Collision/Collision Box Outline (Debug)".mesh.size.x = max_chunk_size
	$"Tile_Collision/Collision Box Outline (Debug)".mesh.size.y = max_chunk_size
	
	$Tile_render.multimesh.instance_count = max_chunk_size*max_chunk_size
	
	var a = 0
	for x in range(max_chunk_size):
			for z in range(max_chunk_size):
				var state = map[x][z]
				$Tile_render.multimesh.set_instance_transform(a, Transform3D(Basis(), Vector3(int(x-(max_chunk_size/2)), 0, int(z-(max_chunk_size/2)))))
				#$Tile_render.multimesh.set_instance_color(2, Color("#42f2f5"))
				match (state):
					tile_type.PLAINS:
						$Tile_render.multimesh.set_instance_color(a, PALE_GREEN)
					tile_type.FOREST:
						$Tile_render.multimesh.set_instance_color(a, GREEN)
					tile_type.MOUNTAINS:
						$Tile_render.multimesh.set_instance_color(a, GREY)
					tile_type.DEEP_OCEAN:
						$Tile_render.multimesh.set_instance_color(a, DARK_BLUE)
					tile_type.DESERT:
						$Tile_render.multimesh.set_instance_color(a, PALE_YELLOW)
					tile_type.OCEAN:
						$Tile_render.multimesh.set_instance_color(a, BLUE)
					tile_type.TUNDRA:
						$Tile_render.multimesh.set_instance_color(a, LIGHT_GREY)
					tile_type.RIVER:
						$Tile_render.multimesh.set_instance_color(a, BABY_BLUE)
				a+=1
	print($Tile_render.multimesh.instance_count)
	print(a)
	
	add_unit(unit_type.settler, Vector2i(0,0))

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("quit"):
			get_tree().quit()

func _process(_delta):
	CameraPosI = Vector2i(int(Camera.position.x),int(Camera.position.z))
	
	if CameraPosI != null && prevCameraPosI != CameraPosI:
		
		$Tile_Collision.position.x = CameraPosI.x
		$Tile_Collision.position.z = CameraPosI.y
		
		#for node in $Tiles.get_children():
		#	node.queue_free()
		
		#for x in range(max_chunk_size):
		#	for z in range(max_chunk_size):
		#		var temp = tile.duplicate()
		#		temp.init(map[x+CameraPosI.x][z+CameraPosI.y], Vector2i(x+CameraPosI.x,z+CameraPosI.y))
		#		temp.position.x = x+CameraPosI.x-(max_chunk_size/2)
		#		temp.position.z = z+CameraPosI.y-(max_chunk_size/2)
		#		$Tiles.add_child(temp)
	prevCameraPosI = CameraPosI
