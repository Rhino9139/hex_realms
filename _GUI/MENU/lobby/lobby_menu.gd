extends Menu

@export var start_game_button: Button
@export var generate_board_button: Button
@export var destroy_board_button: Button


func _ready() -> void:
	Events.board_generated.connect(_on_board_generated)
	Events.destroy_board_requested.connect(_on_board_destroyed)
	if multiplayer.is_server():
		generate_board_button.disabled = false
		destroy_board_button.disabled = false


func _on_board_generated() -> void:
	start_game_button.disabled = false
	generate_board_button.disabled = false


func _on_board_destroyed() -> void:
	start_game_button.disabled = true


func _on_start_game_pressed() -> void:
	Events.host_match_started.emit()


func _on_generate_board_pressed() -> void:
	start_game_button.disabled = true
	generate_board_button.disabled = true
	Events.generate_board_requested.emit()


func _on_main_menu_pressed() -> void:
	Events.lobby_disconnected.emit()
	menu_changed.emit(Header.MAIN)


func _on_destroy_board_pressed() -> void:
	Events.destroy_board_requested.emit()
