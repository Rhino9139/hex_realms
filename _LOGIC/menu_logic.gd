extends Node


func _ready() -> void:
	Events.GAME_START.game_started.connect(_game_started)
	Events.MENU_START.local_name_changed.connect(_local_name_changed)
	Events.MENU_START.host_game_pressed.connect(_host_game_pressed)
	Events.MENU_START.join_game_pressed.connect(_join_game_pressed)
	Events.MENU_START.menu_changed.connect(_menu_changed)
	Events.MENU_START.match_started.connect(_match_started)
	Events.MENU_START.generate_board_requested.connect(_generate_board_requested)
	Events.MENU_START.destroy_board_requested.connect(_destroy_board_requested)
	Events.BOARD_START.board_layout_generated.connect(_board_layout_generated)
	Events.BOARD_START.board_destroyed.connect(_board_destroyed)
	Events.BOARD_START.board_added.connect(_board_added)
	Events.SCREEN_START.turn_order_created.connect(_turn_order_created)


func _game_started() -> void:
	Events.MENU_END.change_menu.emit(MenuManager.Header.MAIN)


func _local_name_changed(new_name: String) -> void:
	Events.GAME_END.change_local_name.emit(new_name)


func _host_game_pressed() -> void:
	Events.NETWORK_END.start_server.emit()
	Events.MENU_END.change_menu.emit(MenuManager.Header.LOBBY)


func _join_game_pressed() -> void:
	Events.NETWORK_END.start_client.emit()
	Events.MENU_END.change_menu.emit(MenuManager.Header.LOBBY)


func _menu_changed(new_header: MenuManager.Header) -> void:
	if new_header == MenuManager.Header.MAIN:
		if multiplayer.is_server():
			Events.NETWORK_END.stop_server.emit()
		else:
			Events.NETWORK_END.stop_client.emit()
	
	Events.MENU_END.change_menu.emit(new_header)


func _match_started() -> void:
	share_match_started.rpc()


@rpc("authority", "call_local")
func share_match_started() -> void:
	Events.MENU_END.clear_menu.emit()
	Events.SCREEN_END.add_screen.emit(Screen.Header.TURN_ORDER)


func _generate_board_requested() -> void:
	Events.BOARD_END.destroy_board.emit()
	Events.BOARD_END.generate_board.emit()
	Events.CHARACTER_END.add_camera.emit()


func _destroy_board_requested() -> void:
	Events.BOARD_END.destroy_board.emit()
	Events.CHARACTER_END.destroy_camera.emit()


func _board_layout_generated() -> void:
	Events.BOARD_END.add_board.emit()


func _board_destroyed() -> void:
	Events.MENU_END.disable_start_game.emit()


func _board_added() -> void:
	Events.MENU_END.enable_start_game.emit()


func _turn_order_created() -> void:
	Events.SCREEN_END.clear_screen.emit()
