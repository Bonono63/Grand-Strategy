extends Node3D

signal interaction

var children
var prev_children

func _process(_delta):
	children = get_children()
	if prev_children != children:
		for child in children:
			if !child.is_connected("interaction", Callable(self, "_input_event")):
				child.connect("interaction", _input_event)
		prev_children = children

func _input_event(a, b, c, d, e):
	emit_signal("interaction", a, b, c, d, e)
