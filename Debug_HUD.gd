extends Panel

@export var main : Node3D
@export var camera : Node3D

func _process(_delta):
	var pos : Vector2i = main.lp_to_gc(camera.position)
	$Label.text = str("x: ",pos.x, "\ny: ", pos.y, "\nz: ", camera.position.z, "\n", Engine.get_frames_per_second())
