extends State

@export var activate_trade: Button
@export var player_trade: Button

var player: Player
var accepted: bool = false
var num_responded: int = 0

func enter() -> void:
	num_responded = 0
	player_trade.toggled.connect(_on_player_trade_pressed)
	activate_trade.pressed.connect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "activate_trade")
	get_tree().call_group("SupplyResources", "enable")
	player = Player.LOCAL_PLAYER
	base.trade_panel.visible = true
	activate_trade.disabled = false

func exit() -> void:
	player = null

func offer_trade() -> void:
	player_trade.toggled.disconnect(_on_player_trade_pressed)
	activate_trade.pressed.disconnect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "deactivate_trade")
	get_tree().call_group("SupplyResources", "disable")
	base.trade_panel.visible = false
	activate_trade.disabled = true

func _on_player_trade_pressed(toggled_on: bool) -> void:
	if toggled_on:
		state_changed.emit("ActiveState")

func _on_trade_accept_pressed() -> void:
	offer_trade()
	if multiplayer.is_server():
		response_trade_share.rpc(player.player_id, player.trade_remove, player.trade_add)
	else:
		request_trade_share.rpc_id(1, player.player_id, player.trade_remove, player.trade_add)

func _on_trade_responded() -> void:
	pass

@rpc("any_peer", "call_remote")
func request_trade_share(id: int, remove: Array[int], add: Array[int]) -> void:
	response_trade_share.rpc(id, remove, add)

@rpc("authority", "call_local")
func response_trade_share(id: int, remove: Array[int], add: Array[int]) -> void:
	var screen: Screen = Screen.CREATE_TRADE_OFFER_SCREEN(id, remove, add)
	screen.trade_closed.connect(_on_trade_responded)

@rpc("any_peer", "call_remote")
func share_response() -> void:
	pass
