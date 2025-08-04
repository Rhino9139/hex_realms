extends Menu

@export var start_game_button: Button
@export var generate_board_button: Button


func _ready() -> void:
	EventTower.board_generated.connect(_on_board_generated)


func _on_start_game_pressed() -> void:
	EventTower.host_match_started.emit()


func _on_generate_board_pressed() -> void:
	start_game_button.disabled = true
	generate_board_button.disabled = true
	EventTower.generate_board_requested.emit()


func _on_board_generated() -> void:
	start_game_button.disabled = false
	generate_board_button.disabled = false


func _on_main_menu_pressed() -> void:
	EventTower.lobby_disconnected.emit()
	menu_changed.emit(Header.MAIN)


func _on_destroy_board_pressed() -> void:
	EventTower.destroy_board_requested.emit()
