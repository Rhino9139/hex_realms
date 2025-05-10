extends State

func enter() -> void:
	Player.LOCAL_PLAYER.settlement_credits = 1
	Player.LOCAL_PLAYER.road_credits = 1
	base.turn_ended.connect(_on_turn_ended)
	BuyButton.ENABLE_SETUP()
	Character.SWAP_TO_HOVER()

func _process(_delta: float) -> void:
	if Player.LOCAL_PLAYER.settlement_credits == 0 and Player.LOCAL_PLAYER.road_credits == 0:
		base.end_turn()

func exit() -> void:
	base.turn_ended.disconnect(_on_turn_ended)
	BuyButton.DISABLE_SETUP()

func _on_turn_ended() -> void:
	state_changed.emit("InactiveState")
