extends State

func enter() -> void:
	Events.player_turn_started.connect(_on_player_turn_started)
	UIButton.DISABLE_UI()
	base.disable_roll()
	Events.camera_deactivated.emit()

func exit() -> void:
	Events.player_turn_started.disconnect(_on_player_turn_started)

func _on_player_turn_started() -> void:
	if Player.LOCAL_PLAYER.turn_index != MatchManager.current_turn:
		return
	if MatchManager.current_round <= 2:
		state_changed.emit("SetupState")
	else:
		state_changed.emit("NeedRollState")
