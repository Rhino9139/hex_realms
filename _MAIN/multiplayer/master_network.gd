class_name MasterNetwork
extends Node

var server: ServerHost
var client: Client


func _ready() -> void:
	Events.server_requested.connect(_on_server_host_created)
	Events.client_requested.connect(_on_client_created)
	Events.lobby_disconnected.connect(_on_lobby_disconnected)


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
		Events.client_destroyed.emit()
	if server:
		server.queue_free()
		Events.server_destroyed.emit()
	PlayerManager.REMOVE_ALL_PLAYERS()
