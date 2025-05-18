class_name Screen
extends Control

const _TURN_ROLL_PATH: String = "uid://ccs81bk4s65rk"
const _MONOPOLY_PATH: String = "uid://c1gixsxmqfk6c"

static func CREATE_TURN_ROLL() -> void:
	var new_screen: Screen = load(_TURN_ROLL_PATH).instantiate()
	MasterGUI.ADD_SCREEN(new_screen)

static func CREATE_MONOPOLY_SCREEN() -> Screen:
	var new_screen: Screen = load(_MONOPOLY_PATH).instantiate()
	MasterGUI.ADD_SCREEN(new_screen)
	return new_screen
