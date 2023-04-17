extends Node3D

signal interaction

var selected = false

func _ready():
	$Area3D.connect("interaction", _input_event)
	#if (selected):
	#	set_color("#fcba03")

func init(gc : Vector2i, _selected : bool):
	name = str(gc)
	selected = _selected

# camera, event, _position, normal, shape_idx
func _input_event(a, b, c, d, e):
	if b is InputEventMouseButton:
		if b.is_action_pressed("left_click"):
			select()
	# camera, event, _position, normal, shape_idx, selection
	emit_signal("interaction", a, b, c, d, e, selected)

func select():
	if selected:
		print("unselected")
		selected = false
	#	set_color("#FFFFFF")
	else:
		print("selected")
		selected = true
	#	set_color("#fcba03")

#func set_color(color : String):
#	var mat = get_active_material(0).duplicate()
#	mat.set("albedo_color", color)
#	set_surface_override_material(0, mat)
