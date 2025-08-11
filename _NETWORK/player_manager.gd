class_name PlayerManager
extends Node

static var MASTER: PlayerManager
static var NUM_PLAYERS: int = 0

const _PATHS: Dictionary[String, String] = {
	"Player" : "uid://cjwp661yn28ll",
}


static func GET_PLAYERS() -> Array[Player]:
	var list: Array[Player]
	for child in MASTER.get_children():
		if child is Player:
			list.append(child)
	return list


static func GET_NUM_PLAYERS() -> int:
	return GET_PLAYERS().size()


static func GET_PLAYER_BY_ID(player_id: int) -> Player:
	for player in GET_PLAYERS():
		if player.player_id == player_id:
			return player
	push_error("Player not found with the ID: ", player_id)
	return null


static func GET_PLAYER_BY_TURN(turn_index: int) -> Player:
	for player in GET_PLAYERS():
		if player.turn_index == turn_index:
			return player
	return null


static func REMOVE_ALL_PLAYERS() -> void:
	for child in MASTER.get_children():
		child.queue_free()


@export var player_spawner: MultiplayerSpawner


func _init() -> void:
	MASTER = self


func _ready() -> void:
	Events.NETWORK_START.server_created.connect(_on_server_created)
	Events.NETWORK_START.server_destroyed.connect(_on_server_destroyed)
	player_spawner.spawn_function = spawn_player


func spawn_player(new_id: int) -> Node:
	var new_player: Player = load(_PATHS["Player"]).instantiate()
	new_player.player_id = new_id
	return new_player


func _on_server_created() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	player_spawner.spawn(1)


func _on_server_destroyed() -> void:
	multiplayer.peer_connected.disconnect(_on_peer_connected)
	REMOVE_ALL_PLAYERS()


func _on_peer_connected(new_id: int) -> void:
	player_spawner.spawn(new_id)
