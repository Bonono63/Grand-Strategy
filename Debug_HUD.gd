extends Panel

@export var main : Node3D
@export var camera : Node3D

func _process(_delta):
	#var pos : Vector2i = main.lp_to_gc(camera.position)
	$Label.text = str("x: ",int(camera.position.x), "\ny: ", int(camera.position.z), "\nz: ", camera.position.y, "\n", Engine.get_frames_per_second())
