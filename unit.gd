extends MeshInstance3D

signal interaction

func _ready():
	$Area3D.connect("interaction", _input_event)

func _input_event(a):
	if a is InputEventMouseButton:
		if a.is_action_pressed("left_click"):
			print(a);
