extends State

func enter() -> void:
	base.turn_started.connect(_on_turn_started)
	UIButton.DISABLE_UI()
	base.disable_roll()
	EventTower.camera_deactivated.emit()

func exit() -> void:
	base.turn_started.disconnect(_on_turn_started)

func _on_turn_started(round_index: int) -> void:
	if round_index <= 1:
		state_changed.emit("SetupState")
	else:
		state_changed.emit("NeedRollState")
