extends State

func enter() -> void:
	if base.turn_started.is_connected(_on_turn_started) == false:
		base.turn_started.connect(_on_turn_started)
	UIButton.DISABLE_UI()
	base.disable_roll()
	Character.SWAP_T0_IDLE()

func _on_turn_started(round_index: int) -> void:
	if round_index <= 1:
		state_changed.emit("SetupState")
	else:
		state_changed.emit("NeedRollState")
