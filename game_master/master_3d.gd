class_name Master3D
extends Node3D

static var MASTER: Master3D

static func ADD_MAP() -> void:
	if MASTER.multiplayer.is_server():
		MASTER.randomize_board()

static func ADD_OBJECT(new_object: Node3D) -> void:
	MASTER.add_child(new_object)

func _init() -> void:
	MASTER = self

func randomize_board() -> void:
	
	Global.HEX_TYPES.shuffle()
	Global.HEX_ROLLS.shuffle()
	Global.PORT_TYPES.shuffle()
	
	var hex_types: Array = Global.HEX_TYPES
	var hex_rolls: Array = Global.HEX_ROLLS
	var port_types: Array = Global.PORT_TYPES
	
	share_board.rpc(hex_types, hex_rolls, port_types)

@rpc("call_local")
func share_board(new_types: Array, new_rolls: Array, new_ports: Array) -> void:
	Global.HEX_TYPES = new_types
	Global.HEX_ROLLS = new_rolls
	Global.PORT_TYPES = new_ports
	MASTER.add_child(HexMap.CREATE())
	MASTER.add_child(Character.CREATE())
	MasterGUI.ENTER_MATCH()
