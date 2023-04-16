class_name unit
extends Node

var selected : bool = false

var health : int = 100
var supply : int = 0
var type : int

func select(_selected):
	selected = _selected

func get_selected() -> bool:
	return selected

func get_health() -> int:
	return health

func set_health(_health : int) -> void:
	health = _health

func get_supply() -> int:
	return supply

func set_supply(_supply : int) -> void:
	supply = _supply

func get_type() -> int:
	return type

func set_type(_type : int) -> void:
	type = _type
