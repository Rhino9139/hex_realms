class_name HUD
extends Control

enum Types{GAME}

const _PATHS: Dictionary[int, String] = {
	Types.GAME : "uid://dlysvvr1aprdc",
}


static func CREATE(new_type: HUD.Types) -> HUD:
	var new_hud: HUD = load(_PATHS[new_type]).instantiate()
	return new_hud


func _ready() -> void:
	EventBus.turn_order_created.connect(_on_turn_order_created)


func _on_turn_order_created() -> void:
	add_child(HUD.CREATE(HUD.Types.GAME))
