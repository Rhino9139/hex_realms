extends State

func enter() -> void:
	UIButton.DISABLE_UI()
	base.disable_roll()
	Character.SWAP_T0_IDLE()
