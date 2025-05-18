extends State

@export var accept_trade: Button

var player: Player

func enter() -> void:
	accept_trade.pressed.connect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "activate_trade")
	get_tree().call_group("SupplyResources", "disable")
	base.trade_panel.visible = true
	player = Player.LOCAL_PLAYER

func exit() -> void:
	accept_trade.pressed.disconnect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "deactivate_trade")
	get_tree().call_group("SupplyResources", "enable")
	base.trade_panel.visible = false

func _on_trade_accept_pressed() -> void:
	Player.LOCAL_PLAYER.trade_resources()
	
	state_changed.emit("InactiveState")
