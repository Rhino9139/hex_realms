class_name Board
extends Node3D

enum Type{STANDARD}

const _PATHS: Dictionary[int, String] = {
	Type.STANDARD : "uid://c2ksqumo8ouyv",
}

var current_board: Node3D


func _ready() -> void:
	Events.BOARD_END.generate_board.connect(_generate_board)
	Events.BOARD_END.destroy_board.connect(_destroy_board)
	Events.BOARD_END.add_board.connect(_add_board)


func _generate_board() -> void:
	Terrain.TYPE_ARRAY.shuffle()
	Global.HEX_ROLLS.shuffle()
	Port.PORT_ARRAY.shuffle()
	Global.ACTION_CARDS.shuffle()
	Events.BOARD_START.board_layout_generated.emit()
	
	share_board.rpc(Terrain.TYPE_ARRAY, Global.HEX_ROLLS, Port.PORT_ARRAY)


func _destroy_board() -> void:
	if current_board:
		current_board.queue_free()
	Events.BOARD_START.board_destroyed.emit()


func _add_board() -> void:
	current_board = load(_PATHS[Type.STANDARD]).instantiate()
	add_child(current_board, true)
	Events.BOARD_START.board_added.emit()


@rpc("authority", "call_remote")
func share_board(new_terrain: Array, new_rolls: Array, new_ports: Array) -> void:
	Terrain.TYPE_ARRAY = new_terrain
	Port.PORT_ARRAY = new_ports
	Global.HEX_ROLLS = new_rolls
	
	Events.BOARD_START.board_layout_generated.emit()
