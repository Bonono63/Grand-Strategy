extends Node3D



const PURPLE = "#6f32a8"
const RED = "#ff0000"
const GREEN = "#37f70c"
const PALE_GREEN = "#9ced55"
const WHITE = "#ffffff"
const GREY = "#474747"
const BLUE = "#0052f5"
const BABY_BLUE = "#42c4fc"
const YELLOW = "#fced42"
const LIGHT_GREY = "#b8b8b8"
const PALE_YELLOW = "#fff8a6"

var state
var global_coordinates : Vector2i

signal interaction

func set_material(node, color):
	var material = node.get_active_material(0).duplicate()
	material.set("albedo_color", color)
	$Main.set_surface_override_material(0, material)

func _ready():
	$Area3D.connect("interaction", _input_event)
	
	#match (state):
	#	type.VOID:
	#		set_material($Main, WHITE)
	#	type.PLAINS:
	#		set_material($Main, PALE_GREEN)
	#	type.FOREST:
	#		set_material($Main, GREEN)
	#	type.MOUNTAINS:
	#		set_material($Main, GREY)
	#	type.DEEP_OCEAN:
	#		set_material($Main, PURPLE)
	#	type.OCEAN:
	#		set_material($Main, BLUE)
	#	type.SAVANAH:
	#		set_material($Main, PALE_YELLOW)
	#	type.TUNDRA:
	#		set_material($Main, LIGHT_GREY)
	#	type.FROZEN_DESERT:
	#		set_material($Main, PALE_YELLOW)
	#	type.RIVER:
	#		set_material($Main, BABY_BLUE)

func _input_event(a, _b):
	if a is InputEventMouseButton:
		if a.is_action_pressed("left_click"):
			#emit_signal("interaction", position, type.find_key(state), global_coordinates)
			#print(a, " ", type.find_key(state), " ", global_coordinates)
			pass

#func init(_state, _global_coordinates):
#	state = _state
#	global_coordinates = _global_coordinates
