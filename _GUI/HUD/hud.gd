class_name HUD
extends Control

enum Header{GAME, PLAYER_RESOURCES}

const _PATHS: Dictionary[int, String] = {
	Header.GAME : "uid://dlysvvr1aprdc",
	Header.PLAYER_RESOURCES : "uid://mss40dxrydbv",
}


func add_hud(header: HUD.Header) -> void:
	var new_hud: Control = load(_PATHS[header]).instantiate()
	add_child(new_hud)


func clear_hud() -> void:
	for child in get_children():
		child.queue_free()
