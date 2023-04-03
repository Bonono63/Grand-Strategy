extends Panel

@export var Tile_collision_area : Area3D
@export var Main : Node3D

func _ready():
	Tile_collision_area.connect("interaction", _input_event)

#camera, event, position, normal, shape_idx
func _input_event(_a, b, c, _d, _e):
	if b is InputEventMouseButton:
		if b.is_action_pressed("left_click"):
			$Label.text = str("Coordinates: (",int(c.x+(Main.max_chunk_size/2)+0.5),",",int(c.z+(Main.max_chunk_size/2)+0.5),")\n", "Tile Type: ",Main.type.find_key(Main.map[int(c.x+(Main.max_chunk_size/2)+0.5)][int(c.z+(Main.max_chunk_size/2)+0.5)]))#, "\nGlobal Coordinate: (" ,c.x,", ", c.y, ")")
