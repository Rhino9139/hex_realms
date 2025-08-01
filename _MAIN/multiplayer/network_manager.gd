class_name NetworkManager
extends Node


func _ready() -> void:
	EventBus.server_created.connect(_on_server_host_created)
	EventBus.client_created.connect(_on_client_created)


func _on_server_host_created() -> void:
	var new_server: ServerHost = ServerHost.new()
	add_child(new_server)



func _on_client_created() -> void:
	var new_client: Client = Client.new()
	add_child(new_client)
