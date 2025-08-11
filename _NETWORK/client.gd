class_name Client
extends Node


var peer: ENetMultiplayerPeer


func _ready() -> void:
	Events.NETWORK_END.start_client.connect(_start_client)
	Events.NETWORK_END.stop_client.connect(_stop_client)


func _start_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ServerHost._LOCAL_HOST, ServerHost._PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_on_server_connected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	print("Starting connection")
	await multiplayer.connected_to_server
	print("Connecting to host at: ", ServerHost._LOCAL_HOST)
	Events.NETWORK_START.client_created.emit()


func _stop_client() -> void:
	peer.close()
	print(peer)
	multiplayer.connected_to_server.disconnect(_on_server_connected)
	multiplayer.server_disconnected.disconnect(_on_server_disconnected)
	Events.NETWORK_START.client_destroyed.emit()


func _on_server_connected() -> void:
	print("Connected To Server")


func _on_server_disconnected() -> void:
	print("Disconnected From Server")
