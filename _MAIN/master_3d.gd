class_name Master3D
extends Node3D

@export var board: Board
@export var character: Character


#func _ready() -> void:
	#
	#Events.add_board_requested.connect(_on_add_board_requested)
	#Events.destroy_board_requested.connect(_on_destroy_board_requested)
	#Events.generate_board_requested.connect(_on_generate_board_requested)
	#
	#
	#Events.player_activated.connect(_on_player_activated)
	#Events.player_deactivated.connect(_on_player_deactivated)


#func _on_add_board_requested() -> void:
	#board.add_board()
#
#
#func _on_destroy_board_requested() -> void:
	#server_destroy_board.rpc()
#
#
#@rpc("authority", "call_local")
#func server_destroy_board() -> void:
	#board.destroy_board()
	#character.destroy_camera()
#
#
#func _on_generate_board_requested() -> void:
	#board.generate_board()
	#board.share_board.rpc(Terrain.TYPE_ARRAY, Global.HEX_ROLLS, Port.PORT_ARRAY)
	#server_generate_board.rpc()
#
#
#@rpc("authority", "call_local")
#func server_generate_board() -> void:
	#board.destroy_board()
	#character.add_camera()
	#Events.add_board_requested.emit()
#
#
#func _on_player_activated() -> void:
	#character.activate_camera()
#
#
#func _on_player_deactivated() -> void:
	#character.deactivate_camera()
