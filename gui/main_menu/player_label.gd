class_name PlayerLabel
extends Label

var player_id: int
var display_name: String:
	set(new_value):
		display_name = new_value
		text = display_name
