class_name ServerHost
extends Node

const _PORT: int = 28282
#const _LOCAL_HOST: String = "127.0.0.1"
const _LOCAL_HOST: String = "192.168.1.64"

static var MAX_PLAYERS: int = 4

var peer: ENetMultiplayerPeer


func _ready() -> void:
	Events.NETWORK_END.start_server.connect(_start_server)
	Events.NETWORK_END.stop_server.connect(_stop_server)


func _start_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(_PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer
	Events.NETWORK_START.server_created.emit()
	print("Hosting on port: ", _PORT)


func _stop_server():
	peer.close()
	Events.NETWORK_START.server_destroyed.emit()
