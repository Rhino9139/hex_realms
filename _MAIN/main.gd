class_name Main
extends Node


static var PLAYER_NAME: String = "New Player"
var debug_name: String


func _ready() -> void:
	Events.GAME_END.change_local_name.connect(_change_local_name)
	
	if OS.is_debug_build():
		DEBUG_setup_multiple_windows()
	
	Events.GAME_START.game_started.emit()


func DEBUG_setup_multiple_windows() -> void:
	if OS.get_cmdline_args().size() > 1:
		var new_name: String = OS.get_cmdline_args()[1]
		var new_pos: Vector2 = Vector2(100, 100)
		PLAYER_NAME = new_name
		debug_name = new_name
		match new_name:
			"Arpos":
				new_pos = Vector2(4000, 200)
			"Valmar":
				new_pos = Vector2(200, 200)
			"Gurdwynn":
				new_pos = Vector2(2400, 200)
		
		DisplayServer.window_set_position(new_pos)


func _change_local_name(new_name: String) -> void:
	PLAYER_NAME = new_name
