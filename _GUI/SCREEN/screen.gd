class_name Screen
extends Control

enum Header{MONOPOLY, PLAYER_TRADE, STEAL, TURN_ORDER, MAIN_ROLL}

const _PATHS: Dictionary[int, String] = {
	Header.MONOPOLY : "uid://c1gixsxmqfk6c",
	Header.PLAYER_TRADE : "uid://ynnsk44tgphk",
	Header.STEAL : "uid://c1la11wpv2w0f",
	Header.TURN_ORDER : "uid://ccs81bk4s65rk",
	Header.MAIN_ROLL : "uid://b17g86bbvfydc",
}

var current_screen: Screen


func _ready() -> void:
	Events.SCREEN_END.add_screen.connect(_add_screen)
	Events.SCREEN_END.clear_screen.connect(_clear_screen)


func _add_screen(header: Screen.Header) -> void:
	_clear_screen()
	
	current_screen = load(_PATHS[header]).instantiate()
	add_child(current_screen)


func _clear_screen() -> void:
	if current_screen:
		current_screen.queue_free()
