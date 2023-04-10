extends Node3D

@export var Camera : Node3D

const size = 1000
const max_chunk_size = 500
#format: [x][y]: tile typw (0-8)
var map = []
#format: [x][y]: unit type (0-5)
var units = []
#format: [x][y]: [population, food]
var cities = [[]]

var hour = 0
var month = 0
var day = 0
var year = 0

var time_stop

var CameraPosI : Vector2i
var prevCameraPosI : Vector2i

enum unit_type
{
	settler,
	soldier,
	mage,
	dragon,
	tank
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
var city_instance := preload("res://city.tscn").instantiate()

func add_unit(a : int, global_coordinates : Vector2i):
	if a == unit_type.settler:
		var instance := settler_unit_instance.duplicate()
		instance.position.x = int(global_coordinates.x-(max_chunk_size/2))
		instance.position.z = int(global_coordinates.y-(max_chunk_size/2))
		units[global_coordinates.x][global_coordinates.y] = a
		$Units.add_child(instance)
	else: if a == unit_type.soldier:
		var instance := soldier_unit_instance.duplicate()
		instance.position.x = int(global_coordinates.x-(max_chunk_size/2))
		instance.position.z = int(global_coordinates.y-(max_chunk_size/2))
		units[int(global_coordinates.x-(max_chunk_size/2))][int(global_coordinates.y-(max_chunk_size/2))] = a
		$Units.add_child(instance)


func add_city(global_coordinates : Vector2i):
	var instance := city_instance.duplicate()
	var x = int(global_coordinates.x-(max_chunk_size/2))
	var z = int(global_coordinates.y-(max_chunk_size/2))
	instance.position.x = x
	instance.position.z = z
	cities[x][z][0] = 0
	cities[x][z][1] = 0
	$Cities.add_child(instance)

func initialize_2d_array(array, length_size, width_size):
	for x in range(length_size):
		var y = []
		y.resize(width_size)
		array.append(y)

func initialize_3d_array(array, length_size, width_size, depth_size):
	for x in range(length_size):
		var y = []
		y.resize(width_size)
		for j in range(width_size):
			var z = []
			z.resize(depth_size)
			y.append(z)
		array.append(y)

func _init():
	initialize_2d_array(map, size, size)
	initialize_2d_array(units, size, size)
	initialize_3d_array(cities, 2, 2, 2)
	print(cities)
	for x in range(size):
		for y in range(size):
			map[x][y] = randi_range(0,tile_type.size()-1)

func _ready():
	#print(tile_type.find_key(map[500][500]))
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
	#print($Tile_render.multimesh.instance_count)
	#print(a)
	
	add_unit(unit_type.settler, Vector2i(250,250))
	add_unit(unit_type.settler, Vector2i(250,251))
	add_city(Vector2i(250,250))
	add_city(Vector2i(252,250))

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("quit"):
			get_tree().quit()

func _process(_delta):
	
	if time_stop:
		hour+=1
	if hour == 24:
		hour = 0
		day+=1
	match(month):
		0:
			if day == 31:
				month +=1
				day = 1
		1:
			if day == 28:
				month +=1
				day = 1
		2:
			if day == 31:
				month +=1
				day = 1
		3:
			if day == 30:
				month +=1
				day = 1
		4:
			if day == 31:
				month +=1
				day = 1
		5:
			if day == 30:
				month +=1
				day = 1
		6:
			if day == 31:
				month +=1
				day = 1
		7:
			if day == 31:
				month +=1
				day = 1
		8:
			if day == 30:
				month +=1
				day = 1
		9:
			if day == 31:
				month +=1
				day = 1
		10:
			if day == 30:
				month +=1
				day = 1
		11:
			if day == 31:
				year += 1
				month = 0
				day = 1
	
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
