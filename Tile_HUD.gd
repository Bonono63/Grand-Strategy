extends Panel

@export var Tile_collision_area : Area3D
@export var Unit_collision_area : Node3D
@export var City_collision_area : Node3D
@export var Main : Node3D

func _ready():
	Tile_collision_area.connect("interaction", _tile_input_event)
	Unit_collision_area.connect("interaction", _unit_input_event)
	City_collision_area.connect("interaction", _city_input_event)

#camera, event, position, normal, shape_idx
func _tile_input_event(_a, b, c, _d, _e):
	var x = int(c.x+(Main.max_chunk_size/2)+0.5)
	var z = int(c.z+(Main.max_chunk_size/2)+0.5)
	$Label.text = str("Coordinates: (",x,",",z,")\n", "Tile Type: ",Main.tile_type.find_key(Main.map[x][z]))

#camera, event, position, normal, shape_idx
func _unit_input_event(_a, b, c, _d, _e):
	var x = int(c.x+(Main.max_chunk_size/2)+0.5)
	var z = int(c.z+(Main.max_chunk_size/2)+0.5)
	$Label.text = str("Coordinates: (",x,",",z,")\n", "Unit Type: ",Main.unit_type.find_key(Main.units[x][z]))

func _city_input_event(_a, _b, c, _d, _e):
	var x = int(c.x+(Main.max_chunk_size/2)+0.5)
	var z = int(c.z+(Main.max_chunk_size/2)+0.5)
	var _city = Main.cities[x][z]
	#print(_city)
	$Label.text = str("Coordinates: (",x,",",z,")\nPopulation: ", _city.population, "\nFood: ", _city.food)


func _process(_delta):
	if $Label.text.is_empty():
		visible = false
	else:
		visible = true
