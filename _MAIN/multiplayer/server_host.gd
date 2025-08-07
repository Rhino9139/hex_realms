class_name ServerHost
extends Node

const _PORT: int = 28282
const _LOCAL_HOST: String = "127.0.0.1"

static var MAX_PLAYERS: int = 4

var peer: MultiplayerPeer


func _ready() -> void:
	name = "ServerHost"
	peer = ENetMultiplayerPeer.new()
	start_host()


func start_host():
	peer.create_server(_PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	Events.server_created.emit()
	print("Hosting on port: ", _PORT)


func _on_peer_connected(id: int):
	print("Player ", id, " connected!")


func _on_peer_disconnected(id: int) -> void:
	print("Player ", id, " disconnected!")
