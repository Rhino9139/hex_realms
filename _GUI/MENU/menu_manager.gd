class_name MenuManager
extends Control

enum Header{MAIN, LOBBY}

const _PATHS: Dictionary[int, String] = {
	Header.MAIN : "uid://w2srhsq0e6wx",
	Header.LOBBY : "uid://d357mywfows4f",
}

var current_menu: Control


func _ready() -> void:
	Events.MENU_END.change_menu.connect(_change_menu)
	Events.MENU_END.clear_menu.connect(_clear_menu)


func add_menu(header: MenuManager.Header) -> void:
	_clear_menu()
	var new_menu: Control = load(_PATHS[header]).instantiate()
	current_menu = new_menu
	add_child(current_menu)


func _change_menu(new_menu: MenuManager.Header) -> void:
	add_menu(new_menu)


func _clear_menu() -> void:
	if current_menu:
		current_menu.queue_free()
