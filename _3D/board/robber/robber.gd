class_name Robber
extends Node3D

const _PATHS: Dictionary[int, String] = {
	0 : "uid://bn28v17yjc7he",
}


static func CREATE() -> Robber:
	var new_rob: Robber = load(_PATHS[0]).instantiate()
	return new_rob


func _ready() -> void:
	Events.BOARD_END.move_robber.connect(_move_robber)


func _move_robber(new_hotspot: HexHotspot) -> void:
	global_position = new_hotspot.global_position
