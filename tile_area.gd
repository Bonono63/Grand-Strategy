extends Area3D

signal interaction

func _input_event(_camera, event, _position, _normal, _shape_idx):
	emit_signal("interaction", event, _position)
