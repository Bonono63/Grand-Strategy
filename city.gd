extends Node3D

var population = 0
var food = 0
var production = 0

func _init(_tile):
	pass

func _ready():
	$MeshInstance3D/Amongus.connect("selected", on_select)

func on_select():
	print("selected")
