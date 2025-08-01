class_name Menu
extends Control

enum Types{MAIN}

const _PATHS: Dictionary[int, String] = {
	Types.MAIN : "uid://w2srhsq0e6wx"
}

static func CREATE(new_type: Menu.Types) -> Menu:
	var new_menu: Menu = load(_PATHS[new_type]).instantiate()
	return new_menu
