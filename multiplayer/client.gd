class_name Client
extends Node

static var MASTER: Client
static var peer: ENetMultiplayerPeer


func _init() -> void:
	MASTER = self


func _ready() -> void:
	peer = ENetMultiplayerPeer.new()
	connect_to_host(ServerHost._LOCAL_HOST, ServerHost._PORT)
	multiplayer.connected_to_server.connect(_on_server_connected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func connect_to_host(host_ip: String, host_port: int) -> void:
	peer.create_client(host_ip, host_port)
	MASTER.multiplayer.multiplayer_peer = peer
	print("Starting connection")
	await MASTER.multiplayer.connected_to_server
	print("Connecting to host at: ", host_ip)


func _on_server_connected() -> void:
	print("Connected To Server")


func _on_server_disconnected() -> void:
	print("Disconnected From Server")
