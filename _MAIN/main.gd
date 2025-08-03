class_name Main
extends Node


static var PLAYER_NAME: String = "New Player"


func _ready() -> void:
	Events.local_name_changed.connect(_on_local_name_changed)
	
	if OS.is_debug_build():
		DEBUG_setup_multiple_windows()
	
	
	Events.program_started.emit()


func DEBUG_setup_multiple_windows() -> void:
	if OS.get_cmdline_args().size() > 1:
		var new_name: String = OS.get_cmdline_args()[1]
		var new_pos: Vector2 = Vector2(100, 100)
		PLAYER_NAME = new_name
	
		match new_name:
			"Valmar":
				new_pos = Vector2(4000, 200)
			"Gurdwynn":
				new_pos = Vector2(200, 200)
			"Kai":
				new_pos = Vector2(2400, 200)
		
		DisplayServer.window_set_position(new_pos)


func _on_local_name_changed(new_name: String) -> void:
	PLAYER_NAME = new_name
