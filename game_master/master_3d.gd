class_name Master3D
extends Node3D

static var MASTER: Master3D

static func ADD_MAP() -> void:
	MASTER.randomize_board()
	MASTER.add_child(HexMap.CREATE())
	MASTER.add_child(Character.CREATE())

static func ADD_OBJECT(new_object: Node3D) -> void:
	MASTER.add_child(new_object)

func _init() -> void:
	MASTER = self

func randomize_board() -> void:
	Global.HEX_TYPES.shuffle()
	Global.HEX_ROLLS.shuffle()
	Global.PORT_TYPES.shuffle()
