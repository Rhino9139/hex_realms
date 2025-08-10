extends Menu

@export var start_game_button: Button
@export var generate_board_button: Button
@export var destroy_board_button: Button


func _ready() -> void:
	start_game_button.disabled = true
	generate_board_button.disabled = true
	destroy_board_button.disabled = true
	if multiplayer.is_server():
		generate_board_button.disabled = false
		destroy_board_button.disabled = false
	
	Events.MENU_END.enable_start_game.connect(_enable_start_game)
	Events.MENU_END.disable_start_game.connect(_disable_start_game)


func _enable_start_game() -> void:
	if multiplayer.is_server():
		start_game_button.disabled = false
		generate_board_button.disabled = false


func _disable_start_game() -> void:
	start_game_button.disabled = true


func _on_start_game_pressed() -> void:
	Events.MENU_START.match_started.emit()


func _on_generate_board_pressed() -> void:
	start_game_button.disabled = true
	generate_board_button.disabled = true
	Events.MENU_START.generate_board_requested.emit()


func _on_destroy_board_pressed() -> void:
	Events.MENU_START.destroy_board_requested.emit()


func _on_main_menu_pressed() -> void:
	Events.MENU_START.lobby_exited.emit()
	Events.MENU_START.menu_changed.emit(Menu.Header.MAIN)
