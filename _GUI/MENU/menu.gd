class_name Menu
extends Control

enum Types{MAIN}

const _PATHS: Dictionary[int, String] = {
	Types.MAIN : "uid://w2srhsq0e6wx"
}

var current_menu: Menu


static func CREATE(new_type: Menu.Types) -> Menu:
	var new_menu: Menu = load(_PATHS[new_type]).instantiate()
	return new_menu



func _ready() -> void:
	EventBus.program_started.connect(_on_program_started)


func _on_program_started() -> void:
	if current_menu:
		current_menu.queue_free()
	
	current_menu = Menu.CREATE(Menu.Types.MAIN)
	add_child(current_menu)
