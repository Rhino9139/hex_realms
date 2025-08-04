class_name Menu
extends Control

@warning_ignore_start("unused_signal")
signal menu_changed(new_header: Header)

enum Header{MAIN, LOBBY}

const _PATHS: Dictionary[int, String] = {
	Header.MAIN : "uid://w2srhsq0e6wx",
	Header.LOBBY : "uid://d357mywfows4f",
}

var current_menu: Menu


func _ready() -> void:
	EventTower.game_opened.connect(_on_game_opened)


func add_menu(header: Menu.Header) -> void:
	clear_menu()
	var new_menu: Menu = load(_PATHS[header]).instantiate()
	current_menu = new_menu
	current_menu.menu_changed.connect(_on_menu_changed)
	add_child(current_menu)


func clear_menu() -> void:
	if current_menu:
		current_menu.queue_free()


func _on_game_opened() -> void:
	add_menu(Menu.Header.MAIN)


func _on_menu_changed(new_menu: Menu.Header) -> void:
	add_menu(new_menu)
