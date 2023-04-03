extends Panel

@export var camera : Node3D

func _process(_delta):
	$Label.text = str("x: ",camera.position.x, "\ny: ", camera.position.y, "\nz: ", camera.position.z, "\n", Engine.get_frames_per_second())
