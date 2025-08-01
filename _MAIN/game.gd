class_name Main
extends Node


var player_header: PlayerHeader


func _ready() -> void:
	if OS.is_debug_build():
		DEBUG_setup_multiple_windows()


func DEBUG_setup_multiple_windows() -> void:
	if OS.get_cmdline_args().size() > 1:
		var new_name: String = OS.get_cmdline_args()[1]
		var new_pos: Vector2 = Vector2(100, 100)
		player_header = PlayerHeader.new(new_name)
	
		match new_name:
			"Valmar":
				new_pos = Vector2(4000, 200)
				EventBus.server_created.emit()
			"Gurdwynn":
				new_pos = Vector2(200, 200)
				EventBus.client_created.emit()
			"Kai":
				new_pos = Vector2(2400, 200)
				EventBus.client_created.emit()
		
		DisplayServer.window_set_position(new_pos)


class PlayerHeader:
	var player_name: String
	var player_id: int
	
	func _init(new_name: String, new_id: int = 0) -> void:
		player_name = new_name
		player_id = new_id
		EventBus.local_name_changed.connect(_on_name_changed)
	
	func _on_name_changed(new_name: String) -> void:
		player_name = new_name
