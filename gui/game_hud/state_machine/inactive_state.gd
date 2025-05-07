extends State

func enter() -> void:
	UIButton.DISABLE_UI()
	base.disable_roll()
	Character.SWAP_T0_IDLE()

func _on_test_timer_timeout() -> void:
	state_changed.emit("NeedRollState")
