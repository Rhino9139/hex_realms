class_name Menu
extends Control

enum Header{MAIN}

const _PATHS: Dictionary[int, String] = {
	Header.MAIN : "uid://w2srhsq0e6wx"
}

var current_menu: Menu


func add_menu(header: Menu.Header) -> void:
	clear_menu()
	
	var new_menu: Menu = load(_PATHS[header]).instantiate()
	current_menu = new_menu
	add_child(current_menu)


func clear_menu() -> void:
	if current_menu:
		current_menu.queue_free()
