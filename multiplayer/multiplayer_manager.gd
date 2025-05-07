class_name MultiplayerManager
extends Node

static var MASTER: MultiplayerManager

static func CREATE_SERVER_HOST() -> void:
	var new_server: ServerHost = ServerHost.new()
	MASTER.add_child(new_server)

static func CREATE_CLIENT() -> void:
	var new_client: Client = Client.new()
	MASTER.add_child(new_client)

static func ADD_PLAYER(new_id: int) -> void:
	var new_player: Player = Player.new()
	new_player.player_id = new_id
	MASTER.add_child(new_player)

static func REMOVE_PLAYER(id: int) -> void:
	for child in MASTER.get_children():
		if child is Player:
			if child.player_id == id:
				child.queue_free()

func _init() -> void:
	MASTER = self
