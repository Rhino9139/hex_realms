class_name Master3D
extends Node3D

static var _MASTER: Master3D

static func add_map() -> void:
	_MASTER.add_child(HexMap.create())

func _init() -> void:
	_MASTER = self

func _ready() -> void:
	randomize_board()
	add_map()

func randomize_board() -> void:
	Global.HEX_TYPES.shuffle()
	Global.HEX_ROLLS.shuffle()
	Global.PORT_TYPES.shuffle()
