class_name Player
extends Node

static var LOCAL_PLAYER: Player

var player_id: int = 0
var player_name: String = "New Player"
var turn_index: int = -1

var resources: Array[int] = [0, 0, 0, 0, 0]
var settlement_credits: int = 0
var road_credits: int = 0
var player_mat: StandardMaterial3D
var player_color: Color
var settlement_count: int = 0
var castle_count: int = 0
var road_count: int = 0

func _ready() -> void:
	if multiplayer.is_server() == false:
		request_id.rpc_id(1)
	elif player_id == 1:
		player_name = Game.GET_NAME()
		Game.CONNECT_NAME_SIGNAL(self)
		LOCAL_PLAYER = self
	player_mat = Global.PLAYER_MATS[get_index()]
	player_color = player_mat.albedo_color

func _on_name_changed(new_name: String) -> void:
	player_name = new_name
	share_name.rpc(new_name)

func settlement_built() -> void:
	settlement_count += 1
	settlement_credits -= 1

func castle_built() -> void:
	settlement_count -= 1
	castle_count += 1

func road_built() -> void:
	road_count += 1
	road_credits -= 1

func change_resource(index: int, amount: int) -> void:
	resources[index] += amount
	GameHUD.UPDATE_RESOURCES()

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
		LOCAL_PLAYER = self

@rpc("any_peer", "call_remote")
func share_name(new_name: String) -> void:
	player_name = new_name
