extends State

func enter() -> void:
	Player.LOCAL_PLAYER.settlement_credits = 1
	Player.LOCAL_PLAYER.road_credits = 1
	base.turn_ended.connect(_on_turn_ended)
	UIButton.ENABLE_UI()
	Character.SWAP_TO_HOVER()

func exit() -> void:
	base.turn_ended.disconnect(_on_turn_ended)
	UIButton.DISABLE_UI()

func _on_turn_ended() -> void:
	state_changed.emit("InactiveState")
