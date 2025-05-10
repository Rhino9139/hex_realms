class_name MultiplayerManager
extends Node

static var MASTER: MultiplayerManager

@export var ms: MultiplayerSpawner

var player_boss: Node
var player_array: Array = []

static func CREATE_SERVER_HOST() -> void:
	var new_server: ServerHost = ServerHost.new()
	MASTER.add_child(new_server)

static func CREATE_CLIENT() -> void:
	var new_client: Client = Client.new()
	MASTER.add_child(new_client)

static func ADD_PLAYER(new_id: int) -> void:
	var new_player: Player = load("uid://bu0f2ax5ubopd").instantiate()
	new_player.player_id = new_id
	new_player.name = str(new_id)
	MASTER.player_boss.add_child(new_player)

static func REMOVE_PLAYER(id: int) -> void:
	for child in MASTER.get_children():
		if child is Player:
			if child.player_id == id:
				child.queue_free()

static func RETURN_PLAYERS() -> Array:
	MASTER.sort_players()
	return MASTER.player_array

func _init() -> void:
	MASTER = self

func _ready() -> void:
	player_boss = find_child("PlayerBoss")

func sort_players() -> void:
	player_array = player_boss.get_children()
	player_array.sort_custom(sort_ascending)

func sort_ascending(a, b) -> bool:
	if a.turn_index < b.turn_index:
		return true
	return false
