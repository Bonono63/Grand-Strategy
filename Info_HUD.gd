extends Control

@export var main : Node3D

func format(day, month, year):
	match(day):
		1:
			$Panel/Label.text = str(main.day, "st , ", month, ", ", main.year)
		2:
			$Panel/Label.text = str(main.day, "nd , ", month, ", ", main.year)
		3:
			$Panel/Label.text = str(main.day, "rd , ", month, ", ", main.year)
		_:
			$Panel/Label.text = str(main.day, "th , ", month, ", ", main.year)

func _process(_delta):
	match(main.month):
		0:
			format(main.day, "January", main.year)
		1:
			format(main.day, "Febuary", main.year)
		2:
			format(main.day, "March", main.year)
		3:
			format(main.day, "April", main.year)
		4:
			format(main.day, "May", main.year)
		5:
			format(main.day, "June", main.year)
		6:
			format(main.day, "July", main.year)
		7:
			format(main.day, "August", main.year)
		8:
			format(main.day, "September", main.year)
		9:
			format(main.day, "November", main.year)
		10:
			format(main.day, "October", main.year)
		11:
			format(main.day, "December", main.year)
