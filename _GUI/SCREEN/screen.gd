class_name Screen
extends Control

enum Header{MONOPOLY, PLAYER_TRADE, STEAL, TURN_ORDER}

const _PATHS: Dictionary[int, String] = {
	Header.MONOPOLY : "uid://c1gixsxmqfk6c",
	Header.PLAYER_TRADE : "uid://ynnsk44tgphk",
	Header.STEAL : "uid://c1la11wpv2w0f",
	Header.TURN_ORDER : "uid://ccs81bk4s65rk",
}

var current_screen: Screen


func add_screen(header: Screen.Header) -> void:
	clear_screen()
	
	var new_screen: Screen = load(_PATHS[header]).instantiate()
	add_child(new_screen)


func clear_screen() -> void:
	if current_screen:
		current_screen.queue_free()
