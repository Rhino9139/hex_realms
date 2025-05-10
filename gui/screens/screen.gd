class_name Screen
extends Control

const _TURN_ROLL_PATH: String = "uid://ccs81bk4s65rk"

static func CREATE_TURN_ROLL() -> void:
	var new_screen: Screen = load(_TURN_ROLL_PATH).instantiate()
	MasterGUI.ADD_SCREEN(new_screen)
