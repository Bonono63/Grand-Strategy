class_name Main
extends Node3D

@export var Camera : Node3D

const size = 1000
const max_chunk_size = 100

#format: [x][y][map layer] : content
var map = []
# map layer 1 tile type
# map layer 2 tile resources
# map layer 3 unit type (and anything that a unit entails inside of a class)
# map layer 4 cities (and anything that a city entails inside of a class)

var units = []
var prev_units = []

var hour = 0
var month = 0
var day = 0
var year = 0

var time_stop

var CameraPosI : Vector2i
var prevCameraPosI : Vector2i

enum map_layer
{
	TILE_TYPE,
	TILE_RESOURCE,
	UNIT_TYPE,
	CITIES
}

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

enum resource_types
{
	wood,
	stone,
	copper,
	tin,
	gold,
	silver,
	iron,
	coal,
	steel,
	chromium,
	gunpowder,
	horses,
	food,
	concrete,
	chocoa,
	tobacco,
	cotton,
	textiles,
	indigo,
	wheat,
	potatoes,
	carrots,
	meat
}

const DARK_BLUE = Color("384ab6")
const RED = Color("d88383")
const GREEN = Color("7dd864")
const PALE_GREEN = Color("b3d88d")
const WHITE = Color("ffffff")
const GREY = Color("b6b6b6")
const BLUE = Color("6b9ed1")
const BABY_BLUE = Color("76d8d8")
const YELLOW = Color("c8b56e")
const LIGHT_GREY = Color("d8d8d8")
const PALE_YELLOW = Color("d8d5a7")

var settler_unit_instance := preload("res://unit.tscn").instantiate()
var soldier_unit_instance := preload("res://unit.tscn").instantiate()
var city_instance := preload("res://city.tscn").instantiate()


########################################################
# Unit functions
#

func get_tile(_position : Vector2i) -> int:
	return map[_position.x][_position.y][map_layer.TILE_TYPE]

func get_tile_string(_position : Vector2i) -> String:
	return str(tile_type.find_key(map[_position.x][_position.y][map_layer.TILE_TYPE].type))

########################################################
# City functions
#
func get_city(_position : Vector2i) -> city:
	return map[_position.x][_position.y][map_layer.CITIES]

#func set_City(_position : Vector2i, a : city) -> void:
#	map[_position.x][_position.y][map_layer.CITIES] = a

func add_city(global_coordinates : Vector2i) -> void:
	var instance := city_instance.duplicate()
	var lc = gc_to_lp(global_coordinates)
	instance.position.x = lc.x
	instance.position.z = lc.y
	instance.init("Berlin")
	var _city = city.new()
	_city.init("Berlin")
	map[global_coordinates.x][global_coordinates.y][map_layer.CITIES] = _city
	$Cities.add_child(instance)

########################################################
# Unit functions
#
func add_unit(a : int, global_coordinates : Vector2i) -> void:
	var lc = gc_to_lp(global_coordinates)
	var _unit = unit.new()
	if a == unit_type.settler:
		set_unit(global_coordinates, _unit)

func get_unit(_position : Vector2i) -> unit:
	return map[_position.x][_position.y][map_layer.UNIT_TYPE]

func get_unit_type_string(_position : Vector2i) -> String:
	return str(unit_type.find_key(map[_position.x][_position.y][map_layer.UNIT_TYPE].type))

func get_unit_type(_position : Vector2i) -> int:
	return map[_position.x][_position.y][map_layer.UNIT_TYPE].type

func get_unit_selected(_position : Vector2i) -> bool:
	return map[_position.x][_position.y][map_layer.UNIT_TYPE].selected

func set_unit(_position : Vector2i, a : unit) -> void:
	map[_position.x][_position.y][map_layer.UNIT_TYPE] = a

func remove_unit(_position : Vector2i):
	map[_position.x][_position.y][map_layer.UNIT_TYPE] = null

func select_unit(_position : Vector2i, select : bool):
	map[_position.x][_position.y][map_layer.UNIT_TYPE].selected = select

########################################################
# Unit mechanics
#

func unit_interaction(a, b, c, d, e, selected) -> void:
	var pos = lp_to_gc(Vector3(c.x, 0, c.z))
	if (get_unit(pos)!=null):
		select_unit(pos, selected)

# create a queue to add units to add and move according to the time using speed etc.
func move_unit(from : Vector2i, to : Vector2i) -> void:
	set_unit(to, get_unit(from))
	remove_unit(from)

func get_selected_units(units : Array) -> Array:
	var selected = []
	
	for i in range(units.size()):
		if get_unit_selected(units[i].global_coordinate):
			selected.append(units[i].global_coordinate)
	
	return selected

func get_units_in_box(camera_gc : Vector2i) -> Array:
	var _units = []
	for i in range(max_chunk_size):
		for j in range(max_chunk_size):
			var unit_gc := Vector2i((i+camera_gc.x)-(max_chunk_size/2), j+camera_gc.y-(max_chunk_size/2))
			if map[unit_gc.x][unit_gc.y][map_layer.UNIT_TYPE] != null:
				#print(unit_gc)
				var temp = unit_array_type.new()
				temp.global_coordinate = unit_gc
				temp.type = get_unit_type(unit_gc)
				_units.append(temp)
	return _units


#************************ redo once the unit area is created (more performant)

func get_movement_action(a, b, c, d, e):
	if b is InputEventMouseButton:
		if b.is_action_pressed("right_click"):
			var pos = lp_to_gc(c)
			var selected := get_selected_units(units)
			for x in range(selected.size()):
				move_unit(units[x].global_coordinate, pos)

########################################################
# General utilities
#

#global coordinates to local position
func gc_to_lp(global_coordinates : Vector2i) -> Vector2i:
	return Vector2i(int(global_coordinates.x-(max_chunk_size/2)),int(global_coordinates.y-(max_chunk_size/2)))

func lp_to_gc(_position : Vector3) -> Vector2i:
	return Vector2i(int(_position.x+(max_chunk_size/2)+0.5), int(_position.z+(max_chunk_size/2)+0.5))

func initialize_2d_array(array, length_size, width_size) -> void:
	for x in range(length_size):
		var y = []
		y.resize(width_size)
		array.append(y)

func initialize_3d_array(array, length_size, width_size, depth_size) -> void:
	for x in range(length_size):
		var y = []
		for j in range(width_size):
			var z = []
			z.resize(depth_size)
			y.append(z)
		array.append(y)

func set_camera_global_coordinates(global_coordinates : Vector2i) -> void:
	$Camera.position.x = int(global_coordinates.x)#-(max_chunk_size/2))
	$Camera.position.z = int(global_coordinates.y)#-(max_chunk_size/2))

########################################################
# Node Functions
#

func _init():
	#initialize_2d_array(unit_chunk, max_chunk_size, max_chunk_size)
	initialize_3d_array(map, size, size, map_layer.size())
	for x in range(size):
		for y in range(size):
			var _tile = tile.new()
			_tile.init(randi_range(0,tile_type.size()-1), [1000,1000,10,0])
			map[x][y][map_layer.TILE_TYPE] = _tile

func _ready():
	Engine.max_fps = 60
	#print(tile_type.find_key(map[500][500]))
	$Tile_Collision/CollisionShape3D.shape.size.x = max_chunk_size
	$Tile_Collision/CollisionShape3D.shape.size.z = max_chunk_size
	$Settler_Collision/CollisionShape3D.shape.size.x = max_chunk_size
	$Settler_Collision/CollisionShape3D.shape.size.z = max_chunk_size
	$"Tile_Collision/Collision Box Outline (Debug)".mesh.size.x = max_chunk_size
	$"Tile_Collision/Collision Box Outline (Debug)".mesh.size.y = max_chunk_size
	
	$Tile_render.multimesh.instance_count = max_chunk_size*max_chunk_size
	
	$Units.connect("interaction", unit_interaction)
	$Tile_Collision.connect("interaction", get_movement_action)
	
	var a = 0
	for x in range(max_chunk_size):
			for z in range(max_chunk_size):
				var state = map[x][z][map_layer.TILE_TYPE].type
				#print(tile_type.find_key(state))
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
	
	for x in range(units.size()):
		if (units[x] != null):
			match(units[x].type):
				unit_type.settler:
					var temp = settler_unit_instance.duplicate()
					var gc : Vector2i = units[x].global_coordinate
					var lp : Vector2i = gc_to_lp(units[x].global_coordinate)
					$Settler_renderer.multimesh.set_instance_transform(x, Transform3D(Basis(), Vector3(int(lp.x-(max_chunk_size/2)), 0, int(lp.y-(max_chunk_size/2)))))
					var selected = get_unit_selected(gc)
					temp.position.x = lp.x
					temp.position.z = lp.y
					temp.init(gc, selected)
					$Units.add_child(temp)
	
	set_camera_global_coordinates(Vector2i(0,0))
	
	for x in 10:
		for y in 10:
			add_unit(unit_type.settler, Vector2i(x,y))
	
	for x in 10:
		for y in 10:
			add_unit(unit_type.settler, Vector2i(-x,-y))
	
	for x in 10:
		for y in 10:
			add_unit(unit_type.settler, Vector2i(-x,y))
	
	for x in 10:
		for y in 10:
			add_unit(unit_type.settler, Vector2i(x,-y))
	#add_unit(unit_type.settler, Vector2i(1,2))
	#add_unit(unit_type.settler, Vector2i(1,3))
	#add_unit(unit_type.settler, Vector2i(1,4))
	#add_unit(unit_type.settler, Vector2i(1,5))
	#add_unit(unit_type.settler, Vector2i(250,251))
	#add_city(Vector2i(0,0))
	#add_city(Vector2i(252,250))

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("quit"):
			get_tree().quit()

# restructure vvvvvvvvv
func population_simulation(cities) -> void:
	for x in range(cities.size()):
		pass
	pass

func _process(_delta):
	
	# Time counter
	
	if time_stop:
		hour+=1
	if hour == 24:
		hour = 0
		day+=1
	match(month):
		0:
			if day > 31:
				month +=1
				day = 1
		1:
			if day > 28:
				month +=1
				day = 1
		2:
			if day > 31:
				month +=1
				day = 1
		3:
			if day > 30:
				month +=1
				day = 1
		4:
			if day > 31:
				month +=1
				day = 1
		5:
			if day > 30:
				month +=1
				day = 1
		6:
			if day > 31:
				month +=1
				day = 1
		7:
			if day > 31:
				month +=1
				day = 1
		8:
			if day > 30:
				month +=1
				day = 1
		9:
			if day > 31:
				month +=1
				day = 1
		10:
			if day > 30:
				month +=1
				day = 1
		11:
			if day > 31:
				year += 1
				month = 0
				day = 1
	
	# general camera and functionalty code
	CameraPosI = Vector2i(int(Camera.position.x),int(Camera.position.z))
	
	if CameraPosI != null && prevCameraPosI != CameraPosI:
		
		$Tile_Collision.position.x = CameraPosI.x
		$Tile_Collision.position.z = CameraPosI.y
		
		$Settler_renderer.position.x = CameraPosI.x
		$Settler_renderer.position.z = CameraPosI.y
		
		var a = 0
		for x in range(max_chunk_size):
				for z in range(max_chunk_size):
					var state = map[int((x+CameraPosI.x)-(max_chunk_size/2)-1)][int((z+CameraPosI.y)-(max_chunk_size/2)-1)][map_layer.TILE_TYPE].type
					$Tile_render.multimesh.set_instance_transform(a, Transform3D(Basis(), Vector3(int((x+CameraPosI.x)-(max_chunk_size/2)), 0, int((z+CameraPosI.y)-(max_chunk_size/2)))))
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
	
	var Camera_gc = lp_to_gc($Camera.position)
	units = get_units_in_box(Camera_gc)
	if units != prev_units:
		if (units != null):
			for child in $Units.get_children():
				child.queue_free()
			
			for x in range(units.size()):
				if (units[x] != null):
					match(units[x].type):
						unit_type.settler:
							#var temp = settler_unit_instance.duplicate()
							var gc : Vector2i = units[x].global_coordinate
							var lp : Vector2i = Vector2i(int(units[x].global_coordinate.x-(max_chunk_size/2)),int(units[x].global_coordinate.y-(max_chunk_size/2)))
							$Settler_renderer.multimesh.set_instance_transform(x, Transform3D(Basis(), Vector3(lp.x, 0.0625, lp.y)))
							if (get_unit_selected(gc)):
								$Settler_renderer.multimesh.set_instance_color(x, "#fcba03")
							else:
								$Settler_renderer.multimesh.set_instance_color(x, "#FFFFFF")
							$Settler_renderer.multimesh.instance_count = units.size()
							#var selected = get_unit_selected(gc)
							#temp.position.x = lp.x
							#temp.position.z = lp.y
							#temp.init(gc, selected)
							#$Units.add_child(temp)
	
	prevCameraPosI = CameraPosI
	prev_units = units
	#print(units)
	#units = []
