class_name Client
extends Node


var peer: ENetMultiplayerPeer


func _ready() -> void:
	name = "Client"
	peer = ENetMultiplayerPeer.new()
	start_client()


func start_client():
	connect_to_host(ServerHost._LOCAL_HOST, ServerHost._PORT)
	multiplayer.connected_to_server.connect(_on_server_connected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	Events.client_created.emit()


func connect_to_host(host_ip: String, host_port: int) -> void:
	peer.create_client(host_ip, host_port)
	multiplayer.multiplayer_peer = peer
	print("Starting connection")
	await multiplayer.connected_to_server
	print("Connecting to host at: ", host_ip)


func _on_server_connected() -> void:
	print("Connected To Server")


func _on_server_disconnected() -> void:
	print("Disconnected From Server")
