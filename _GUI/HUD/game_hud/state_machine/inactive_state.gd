extends State

func enter() -> void:
	Events.player_turn_started.connect(_on_player_turn_started)
	Events.player_deactivated.emit()


func exit() -> void:
	Events.player_turn_started.disconnect(_on_player_turn_started)


func _on_player_turn_started() -> void:
	var local_player: Player = PlayerManager.GET_PLAYER_BY_ID(multiplayer.get_unique_id())
	if Player.LOCAL_PLAYER.turn_index != MatchManager.current_turn:
		return
	print("Player turn started: ", multiplayer.get_unique_id())
	if MatchManager.current_round <= 2:
		state_changed.emit("SetupState")
	else:
		state_changed.emit("NeedRollState")
