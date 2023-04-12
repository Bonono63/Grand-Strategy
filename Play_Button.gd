extends CheckBox

@export var main : Node3D

func _toggled(_button_pressed):
	if _button_pressed:
		main.time_stop = true
	else:
		main.time_stop = false
