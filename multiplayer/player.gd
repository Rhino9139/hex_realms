class_name Player
extends Node

static var LOCAL_PLAYER: Player

var player_id: int = 0
var player_name: String = "New Player"
var turn_index: int = -1

var resources: Array[int] = [0, 0, 0, 0, 0]

func _ready() -> void:
	if multiplayer.is_server() == false:
		request_id.rpc_id(1)
	elif player_id == 1:
		player_name = Game.GET_NAME()
		Game.CONNECT_NAME_SIGNAL(self)

func _on_name_changed(new_name: String) -> void:
	player_name = new_name
	share_name.rpc(new_name)

@rpc("any_peer")
func request_id() -> void:
	var id: int = multiplayer.get_remote_sender_id()
	response_id.rpc_id(id, player_id)
	if id != player_id:
		share_name.rpc_id(id, player_name)

@rpc("authority")
func response_id(new_id: int) -> void:
	player_id = new_id
	if player_id == multiplayer.get_unique_id():
		player_name = Game.GET_NAME()
		Game.CONNECT_NAME_SIGNAL(self)
		share_name.rpc(player_name)

@rpc("any_peer", "call_remote")
func share_name(new_name: String) -> void:
	player_name = new_name
