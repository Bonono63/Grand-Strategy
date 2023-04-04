extends Area3D

signal interaction

func _input_event(camera, event, _position, normal, shape_idx):
	emit_signal("interaction", camera, event, _position, normal, shape_idx)
