extends State

@export var supply_button: Button
@export var accept_trade: Button

var player: Player

func enter() -> void:
	supply_button.toggled.connect(_on_supply_trade_toggled)
	accept_trade.pressed.connect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "activate_trade")
	get_tree().call_group("SupplyResources", "enable")
	base.trade_panel.visible = true
	supply_button.disabled = false
	player = Player.LOCAL_PLAYER

func update(_delta: float) -> void:
	var card_credits: int = 0
	var card_add: int = 0
	for i in 5:
		@warning_ignore("integer_division")
		card_credits += int(player.trade_remove[i] / player.trade_ratios[i])
		card_add += player.trade_add[i]
	if card_add != card_credits or card_add == 0:
		accept_trade.disabled = true
	else:
		accept_trade.disabled = false

func exit() -> void:
	accept_trade.pressed.disconnect(_on_trade_accept_pressed)
	supply_button.toggled.disconnect(_on_supply_trade_toggled)
	get_tree().call_group("PlayerResourceCards", "deactivate_trade")
	get_tree().call_group("SupplyResources", "disable")
	base.trade_panel.visible = false
	supply_button.set_pressed_no_signal(false)

func _on_trade_accept_pressed() -> void:
	Player.LOCAL_PLAYER.trade_resources()
	state_changed.emit("ActiveState")

func _on_supply_trade_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		state_changed.emit("ActiveState")
