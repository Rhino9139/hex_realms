class_name HUD
extends Control

enum Header{STANDARD}

const _PATHS: Dictionary[int, String] = {
	Header.STANDARD : "uid://dlysvvr1aprdc",
}

var current_hud: HUD


func _ready() -> void:
	Events.HUD_END.add_hud.connect(_add_hud)
	Events.HUD_END.clear_hud.connect(_clear_hud)


func _add_hud(header: HUD.Header) -> void:
	current_hud = load(_PATHS[header]).instantiate()
	add_child(current_hud)


func _clear_hud() -> void:
	if current_hud:
		current_hud.queue_free()
