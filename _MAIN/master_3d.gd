class_name Master3D
extends Node3D


func _ready() -> void:
	Events.host_match_started.connect(_on_match_started)


func _on_match_started() -> void:
	randomize_board()


func randomize_board() -> void:
	Global.HEX_TYPES.shuffle()
	Global.HEX_ROLLS.shuffle()
	Global.PORT_TYPES.shuffle()
	Global.ACTION_CARD_TYPES.shuffle()
	
	var hex_types: Array = Global.HEX_TYPES
	var hex_rolls: Array = Global.HEX_ROLLS
	var port_types: Array = Global.PORT_TYPES
	
	share_board.rpc(hex_types, hex_rolls, port_types)


@rpc("authority", "call_local")
func share_board(new_types: Array, new_rolls: Array, new_ports: Array) -> void:
	Global.HEX_TYPES = new_types
	Global.HEX_ROLLS = new_rolls
	Global.PORT_TYPES = new_ports
	
	add_child(HexMap.CREATE())
	add_child(Character.CREATE())
	
	Events.board_shared.emit()
