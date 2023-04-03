extends Node3D

@export var Main : Node3D

signal interaction

func _process(_delta):
	for x in get_children():
		if !x.is_connected("interaction", Callable(self, "_telegram")):
			x.connect("interaction", _telegram)

func _telegram(a, b, c):
	emit_signal("interaction", a, b, c)
