extends MeshInstance3D

signal interaction

func _ready():
	$Area3D.connect("interaction", _input_event)

# camera, event, _position, normal, shape_idx
func _input_event(a, b, c, d, e):
	emit_signal("interaction", a, b, c, d, e)
