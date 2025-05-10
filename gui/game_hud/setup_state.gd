extends State

func enter() -> void:
	base.turn_ended.connect(_on_turn_ended)
	UIButton.ENABLE_UI()
	Character.SWAP_TO_HOVER()

func exit() -> void:
	base.turn_ended.disconnect(_on_turn_ended)
	UIButton.DISABLE_UI()

func _on_turn_ended() -> void:
	state_changed.emit("InactiveState")
