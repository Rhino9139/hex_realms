extends State

func _init() -> void:
	super()
	

func enter() -> void:
	UIButton.DISABLE_UI()
	base.disable_roll()
	Character.SWAP_T0_IDLE()

func _on_turn_started(round_index: int) -> void:
	if round_index <= 1:
		state_changed.emit("SetupState")
	else:
		state_changed.emit("NeedRollState")
