extends State

func enter() -> void:
	base.turn_ended.connect(_on_turn_ended)
	UIButton.ENABLE_UI()
	Character.SWAP_TO_HOVER()
	base.end_turn_button.disabled = false
	base.end_turn_button.visible = true
	get_tree().call_group("BuyButton", "check_cost")

func exit() -> void:
	base.turn_ended.disconnect(_on_turn_ended)
	UIButton.DISABLE_UI()
	base.end_turn_button.disabled = true
	base.end_turn_button.visible = false

func _on_turn_ended() -> void:
	state_changed.emit("InactiveState")
