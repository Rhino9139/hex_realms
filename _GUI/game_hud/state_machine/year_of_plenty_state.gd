extends State

@export var accept_trade: Button

var player: Player
var count: int = 0

func enter() -> void:
	count = 0
	accept_trade.pressed.connect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "activate_trade")
	get_tree().call_group("SupplyResources", "enable")
	base.trade_panel.visible = true
	player = Player.LOCAL_PLAYER

func update(_delta: float) -> void:
	count = 0
	for i in 5:
		count += player.trade_add[i]
	if count == 2:
		accept_trade.disabled = false
	else:
		accept_trade.disabled = true

func exit() -> void:
	accept_trade.disabled = true
	accept_trade.pressed.disconnect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "deactivate_trade")
	get_tree().call_group("SupplyResources", "disable")
	base.trade_panel.visible = false

func _on_trade_accept_pressed() -> void:
	Player.LOCAL_PLAYER.trade_resources()
	state_changed.emit("ActiveState")
