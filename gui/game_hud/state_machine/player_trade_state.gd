extends State

@export var activate_trade: Button
@export var player_trade: Button

var player: Player

func enter() -> void:
	player_trade.toggled.connect(_on_player_trade_started)
	activate_trade.pressed.connect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "activate_trade")
	get_tree().call_group("SupplyResources", "enable")
	player = Player.LOCAL_PLAYER
	base.trade_panel.visible = true
	activate_trade.disabled = false

func exit() -> void:
	player = null

func offer_trade() -> void:
	player_trade.toggled.disconnect(_on_player_trade_started)
	activate_trade.pressed.disconnect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "deactivate_trade")
	get_tree().call_group("SupplyResources", "disable")
	base.trade_panel.visible = false
	activate_trade.disabled = true

func _on_player_trade_started(toggled_on: bool) -> void:
	if toggled_on:
		state_changed.emit("ActiveState")

func done_cutting() -> void:
	activate_trade.pressed.disconnect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "deactivate_trade")
	get_tree().call_group("SupplyResources", "disable")
	base.trade_panel.visible = false

func _on_trade_accept_pressed() -> void:
	offer_trade()
	Screen.CREATE_TRADE_OFFER_SCREEN(player.player_id, player.trade_remove, player.trade_add)
