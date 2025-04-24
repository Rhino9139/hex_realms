class_name Master3D
extends Node3D

static var MASTER: Master3D

static func ADD_MAP() -> void:
	MASTER.randomize_board()
	MASTER.add_child(HexMap.CREATE())

func _init() -> void:
	MASTER = self

func randomize_board() -> void:
	Global.HEX_TYPES.shuffle()
	Global.HEX_ROLLS.shuffle()
	Global.PORT_TYPES.shuffle()
