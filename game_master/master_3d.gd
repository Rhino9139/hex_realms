class_name Master3D
extends Node3D

static var _MASTER: Master3D

static func add_map() -> void:
	_MASTER.add_child(HexMap.create())

func _init() -> void:
	_MASTER = self

func _ready() -> void:
	Global.HEX_TYPES.shuffle()
	print(Global.HEX_TYPES)
	add_map()
