extends State

func enter() -> void:
	base.turn_ended.connect(_on_turn_ended)
	Player.LOCAL_PLAYER.item_bought.connect(_on_item_bought)
	UIButton.ENABLE_UI()
	Character.SWAP_TO_HOVER()
	base.end_turn_button.disabled = false
	base.end_turn_button.visible = true
	get_tree().call_group("BuyButton", "check_cost")

func exit() -> void:
	base.turn_ended.disconnect(_on_turn_ended)
	Player.LOCAL_PLAYER.item_bought.disconnect(_on_item_bought)
	UIButton.DISABLE_UI()
	base.end_turn_button.disabled = true
	base.end_turn_button.visible = false

func _on_item_bought(item: String) -> void:
	match item:
		Global._SETTLEMENT:
			Player.LOCAL_PLAYER.pay_settlement()
		Global._CASTLE:
			Player.LOCAL_PLAYER.pay_castle()
		Global._ROAD:
			Player.LOCAL_PLAYER.pay_road()
		Global._CARD:
			Player.LOCAL_PLAYER.pay_card()
	get_tree().call_group("BuyButton", "check_cost")

func _on_turn_ended() -> void:
	state_changed.emit("InactiveState")
