extends State

@export var activate_trade: Button
@export var player_trade: Button

var player: Player
var num_responded: int = 0
var offer_player_id: int = 0
var completed: bool = false
var offer_add: Array[int]
var offer_remove: Array[int]


func enter() -> void:
	completed = false
	num_responded = 0
	player_trade.toggled.connect(_on_player_trade_pressed)
	activate_trade.pressed.connect(_on_trade_offer_pressed)
	get_tree().call_group("PlayerResourceCards", "activate_trade")
	get_tree().call_group("SupplyResources", "enable")
	player = Player.LOCAL_PLAYER
	base.trade_panel.visible = true
	activate_trade.disabled = false


func exit() -> void:
	player = null
	player_trade.set_pressed_no_signal(false)


func offer_trade() -> void:
	offer_add = player.trade_add
	offer_remove = player.trade_remove
	player_trade.toggled.disconnect(_on_player_trade_pressed)
	activate_trade.pressed.disconnect(_on_trade_offer_pressed)
	get_tree().call_group("PlayerResourceCards", "deactivate_trade")
	get_tree().call_group("SupplyResources", "disable")
	base.trade_panel.visible = false
	activate_trade.disabled = true


func _on_player_trade_pressed(toggled_on: bool) -> void:
	if toggled_on:
		state_changed.emit("ActiveState")


func _on_trade_offer_pressed() -> void:
	offer_trade()
	share_trade_offer.rpc(offer_remove, offer_add)


func _on_trade_responded(accepted: bool) -> void:
	respond_to_offer.rpc_id(offer_player_id, accepted)


@rpc("any_peer", "call_remote")
func share_trade_offer(remove: Array[int], add: Array[int]) -> void:
	offer_player_id = multiplayer.get_remote_sender_id()
	#TODO create trade offer screen


@rpc("any_peer", "call_remote")
func respond_to_offer(accepted: bool) -> void:
	var responder_id: int = multiplayer.get_remote_sender_id()
	print(responder_id, " Responded")
	num_responded += 1
	if accepted and !completed:
		print(offer_add)
		print(offer_remove)
		completed = true
		player.manual_trade(offer_add, offer_remove)
		share_trade_confirm.rpc_id(responder_id, offer_remove, offer_add)
	if num_responded == PlayerManager.GET_NUM_PLAYERS() - 1:
		state_changed.emit("ActiveState")


@rpc("any_peer", "call_remote")
func share_trade_confirm(trade_add: Array[int], trade_remove: Array[int]) -> void:
	player = Player.LOCAL_PLAYER
	player.manual_trade(trade_add, trade_remove)
	print("Responder")
	print(trade_add)
	print(trade_remove)
