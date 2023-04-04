extends Node3D

const zoom_increment = 0.5
const max_zoom = 8.5
const min_zoom = 0.5

@export var zoom_speed = 0.09
@export var mouse_sensitivity = 0.005

var zoom = 0.5

var x = 0 
var y = 0

var position_control = false
var rotation_control = false
var free_cam = false

func _unhandled_input(event):
	if event.is_action_pressed("reset_camera"):
		rotation.y = 0
		zoom = 0.5
		position.y = 0
		$Camera.rotation.x = PI
	if event.is_action_pressed("zoom_in"):
		if zoom > min_zoom : zoom-=zoom_increment
	if event.is_action_pressed("zoom_out"):
		if zoom < max_zoom : zoom+=zoom_increment
	if event is InputEventMouse:
		if event is InputEventMouseMotion:
			if event.relative.x != 0:
				x = -event.relative.x
			if event.relative.y != 0:
				y = event.relative.y
		if event is InputEventMouseButton:
			if event.is_action_pressed("middle_click"):
				position_control = true
			if event.is_action_released("middle_click"):
				position_control = false
			if event.is_action_pressed("right_click"):
				rotation_control = true
			if event.is_action_released("right_click"):
				rotation_control = false
	if event is InputEventKey:
		if event.is_action_pressed("free_cam"):
			if free_cam == true:
				free_cam = false
				print("free_cam ",free_cam)
			else:
				print("free_cam ",free_cam)
				free_cam = true

var _rotation_y : float
var prev_zoom = 0.5

var old_pos : Vector3
var old_rotation : Vector3

func _process(_delta):
	if position_control:
		translate_object_local(Vector3(x*mouse_sensitivity,y*mouse_sensitivity,0))
	
	if rotation_control:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_rotation_y = (x*mouse_sensitivity)
		rotate_y(_rotation_y)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	position.y = zoom
	position.y = clamp(position.y, min_zoom, max_zoom)
	if zoom != prev_zoom:
		if !(prev_zoom-zoom < 0):
			$Camera.rotate_object_local(Vector3(1,0,0), PI/36)
		else:
			$Camera.rotate_object_local(Vector3(-1,0,0), PI/36)
	
	x = 0
	y = 0
	_rotation_y = 0
	prev_zoom = zoom
