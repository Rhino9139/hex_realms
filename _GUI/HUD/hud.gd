class_name HUD
extends Control

enum Header{GAME}

const _PATHS: Dictionary[int, String] = {
	Header.GAME : "uid://dlysvvr1aprdc",
}

var current_hud: HUD


func add_hud(header: HUD.Header) -> void:
	clear_hud()
	
	var new_hud: HUD = load(_PATHS[header]).instantiate()
	add_child(new_hud)


func clear_hud() -> void:
	if current_hud:
		current_hud.queue_free()
