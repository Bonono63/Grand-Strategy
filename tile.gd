class_name tile
extends Node

var type : int
var resources : Array

func init(_type : int, _resources : Array) -> void:
	type = _type
	resources = _resources
	resources.resize(10)

func get_resources() -> Array:
	return resources

func get_type() -> int:
	return type
