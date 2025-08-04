class_name Robber
extends Node3D

const _PATHS: Dictionary[int, String] = {
	0 : "uid://bn28v17yjc7he",
}


static func CREATE() -> Robber:
	var new_rob: Robber = load(_PATHS[0]).instantiate()
	return new_rob


func _ready() -> void:
	EventTower.move_robber_requested.connect(_on_move_robber_requested)


func _on_move_robber_requested(new_pos: Vector3) -> void:
	global_position = new_pos
	EventTower.robber_moved.emit()
