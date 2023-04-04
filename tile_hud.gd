extends Panel

@export var Tile_collision_area : Area3D
@export var Unit_collision_area : Node3D
@export var Main : Node3D

func _ready():
	Tile_collision_area.connect("interaction", _tile_input_event)
	Unit_collision_area.connect("interaction", _unit_input_event)

#camera, event, position, normal, shape_idx
func _tile_input_event(_a, b, c, _d, _e):
	#if b is InputEventMouseButton:
		#if b.is_action_pressed("left_click"):
	$Label.text = str("Coordinates: (",int(c.x+(Main.max_chunk_size/2)+0.5),",",int(c.z+(Main.max_chunk_size/2)+0.5),")\n", "Tile Type: ",Main.tile_type.find_key(Main.map[int(c.x+(Main.max_chunk_size/2)+0.5)][int(c.z+(Main.max_chunk_size/2)+0.5)]))#, "\nGlobal Coordinate: (" ,c.x,", ", c.y, ")")

#camera, event, position, normal, shape_idx
func _unit_input_event(_a, b, c, _d, _e):
	$Label.text = str("Coordinates: (",int(c.x+(Main.max_chunk_size/2)+0.5),",",int(c.z+(Main.max_chunk_size/2)+0.5),")\n", "Unit Type: ",Main.unit_type.find_key(Main.units[int(c.x+(Main.max_chunk_size/2)+0.5)][int(c.z+(Main.max_chunk_size/2)+0.5)]))

func _process(_delta):
	if $Label.text.is_empty():
		visible = false
	else:
		visible = true
