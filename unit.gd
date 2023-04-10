extends MeshInstance3D

signal interaction

var selected = false

func _ready():
	$Area3D.connect("interaction", _input_event)

# camera, event, _position, normal, shape_idx
func _input_event(a, b, c, d, e):
	if b is InputEventMouseButton:
		if b.is_action_pressed("left_click"):
			selected = true
			print("selected")
	
	emit_signal("interaction", a, b, c, d, e)
