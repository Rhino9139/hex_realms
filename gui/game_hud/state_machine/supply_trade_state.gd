extends State

@export var supply_button: Button
@export var accept_trade: Button

func enter() -> void:
	supply_button.toggled.connect(_on_supply_trade_toggled)
	accept_trade.pressed.connect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "activate_trade")
	base.trade_panel.visible = true
	supply_button.disabled = false

func exit() -> void:
	accept_trade.pressed.disconnect(_on_trade_accept_pressed)
	supply_button.toggled.disconnect(_on_supply_trade_toggled)
	get_tree().call_group("PlayerResourceCards", "deactivate_trade")
	base.trade_panel.visible = false
	supply_button.set_pressed_no_signal(false)

func _on_trade_accept_pressed() -> void:
	Player.LOCAL_PLAYER.trade_resources()
	state_changed.emit("ActiveState")

func _on_supply_trade_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		state_changed.emit("ActiveState")
