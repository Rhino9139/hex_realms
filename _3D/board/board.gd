class_name Board
extends Node3D

enum Type{STANDARD}

const _PATHS: Dictionary[int, String] = {
	Type.STANDARD : "uid://c2ksqumo8ouyv",
}

static var HEX_TYPES: Array[int] = [
	0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5
]

var current_board: Node3D


func add_board() -> void:
	current_board = load(_PATHS[Type.STANDARD]).instantiate()
	add_child(current_board)


func destroy_board() -> void:
	if current_board:
		current_board.queue_free()


func generate_board() -> void:
	Terrain.TYPE_ARRAY.shuffle()
	Port.PORT_ARRAY.shuffle()
	
	Global.HEX_ROLLS.shuffle()
	Global.ACTION_CARDS.shuffle()
	
	var terrain_types: Array[Terrain.Type] = Terrain.TYPE_ARRAY
	var hex_rolls: Array = Global.HEX_ROLLS
	var port_types: Array = Port.PORT_ARRAY
	
	share_board.rpc(terrain_types, hex_rolls, port_types)


@rpc("authority", "call_local")
func share_board(new_terrain: Array, new_rolls: Array, new_ports: Array) -> void:
	Terrain.TYPE_ARRAY = new_terrain
	Port.PORT_ARRAY = new_ports
	
	Global.HEX_ROLLS = new_rolls
	
	EventTower.board_generated.emit()
	EventTower.add_board_requested.emit()
