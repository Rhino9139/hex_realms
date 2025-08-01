class_name Screen
extends Control

enum Headers{MONOPOLY, PLAYER_TRADE, STEAL, TURN_ORDER}

const _PATHS: Dictionary[int, String] = {
	Headers.MONOPOLY : "uid://c1gixsxmqfk6c",
	Headers.PLAYER_TRADE : "uid://ynnsk44tgphk",
	Headers.STEAL : "uid://c1la11wpv2w0f",
	Headers.TURN_ORDER : "uid://ccs81bk4s65rk",
}

static func CREATE(new_header: Screen.Headers) -> Screen:
	var new_screen: Screen = load(_PATHS[new_header]).instantiate()
	return new_screen
