class_name Robber
extends Node3D

const _PATH: String = "uid://bn28v17yjc7he"

static var MASTER: Robber

var spawn_pos: Vector3

static func CREATE(new_spawn: Vector3) -> void:
	var new_rob: Robber = load(_PATH).instantiate()
	new_rob.spawn_pos = new_spawn
	Master3D.ADD_OBJECT(new_rob)

static func MOVE_ROBBER(new_pos: Vector3) -> void:
	MASTER.global_position = new_pos

func _ready() -> void:
	MASTER = self
	global_position = spawn_pos
