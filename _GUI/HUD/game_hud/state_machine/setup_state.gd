extends State

func enter() -> void:
	get_tree().call_group("SetupRoads", "remove_from_group", "SetupRoads")
	Player.LOCAL_PLAYER.settlement_built.connect(_on_settlement_built)
	Player.LOCAL_PLAYER.road_built.connect(_on_road_built)
	base.turn_ended.connect(_on_turn_ended)
	#Character.SWAP_TO_HOVER()
	BuyButton.ENABLE_SETTLEMENT()

func exit() -> void:
	base.turn_ended.disconnect(_on_turn_ended)
	Player.LOCAL_PLAYER.settlement_built.disconnect(_on_settlement_built)
	Player.LOCAL_PLAYER.road_built.disconnect(_on_road_built)
	if MatchManager.current_round == 2:
		get_tree().call_group("Empty", "remove_from_group", "Empty")

func _on_settlement_built() -> void:
	BuyButton.DISABLE_SETTLEMENT()
	BuyButton.ENABLE_ROAD()

func _on_road_built() -> void:
	BuyButton.DISABLE_ROAD()
	base.end_turn()
	get_tree().call_group("SetupRoads", "make_unavailable")

func _on_turn_ended() -> void:
	state_changed.emit("InactiveState")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_B:
			print("CHEAT")
			state_changed.emit("ActiveState")
