extends Area3D

signal selected

func _input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			emit_signal("selected")
			print("asdg")
