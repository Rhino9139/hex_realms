class_name NetworkManager
extends Node

var server: ServerHost
var client: Client


func _ready() -> void:
	EventTower.server_requested.connect(_on_server_host_created)
	EventTower.client_requested.connect(_on_client_created)
	EventTower.lobby_disconnected.connect(_on_lobby_disconnected)


func _on_server_host_created() -> void:
	server = ServerHost.new()
	add_child(server)


func _on_client_created() -> void:
	client = Client.new()
	add_child(client)


func _on_lobby_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	if client:
		client.queue_free()
		EventTower.client_destroyed.emit()
	if server:
		server.queue_free()
		EventTower.server_destroyed.emit()
	PlayerManager.REMOVE_ALL_PLAYERS()
