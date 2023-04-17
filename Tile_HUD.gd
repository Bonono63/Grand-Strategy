extends Panel

@export var Tile_collision_area : Area3D
@export var Unit_collision_area : Node3D
@export var City_collision_area : Node3D
@export var main : Node3D

func _ready():
	Tile_collision_area.connect("interaction", _tile_input_event)
	Unit_collision_area.connect("interaction", _unit_input_event)
	City_collision_area.connect("interaction", _city_input_event)

#camera, event, position, normal, shape_idx
func _tile_input_event(_a, b, c, _d, _e):
	var pos = tile_convert_interact_position(c) 
	$Label.text = str("Coordinates: (",pos.x,",",pos.y,")\nTile Type: ",main.get_tile_string(pos))

#camera, event, position, normal, shape_idx
func _unit_input_event(_a, b, c, _d, _e, selected):
	var pos = unit_convert_interact_position(c)
	$Label.text = str("Coordinates: (",pos.x,",",pos.y,")\nUnit Type: ",main.get_unit_type_string(pos), "\nSelected: ",selected)

func _city_input_event(_a, _b, c, _d, _e):
	var pos = tile_convert_interact_position(c)
	var _city = main.get_city(Vector2i(pos.x,pos.y))
	$Label.text = str("Coordinates: (",pos.x,",",pos.y,")\nPopulation: ", _city.population, "\nFood: ", _city.food)

func _process(_delta):
	if $Label.text.is_empty():
		visible = false
	else:
		visible = true

func tile_convert_interact_position(_position : Vector3) -> Vector2i:
	return Vector2i(int(_position.x+(main.max_chunk_size/2)+0.5), int(_position.z+(main.max_chunk_size/2)+0.5))

func unit_convert_interact_position(_position : Vector3) -> Vector2i:
	return Vector2i(int(_position.x+(main.max_chunk_size/2)+0.5), int(_position.z+(main.max_chunk_size/2)+0.5))
