extends State

@export var accept_trade: Button

var player: Player
var players_ready: Array[int] = []
var done: bool = false
var cut_target: int = 0
var cut_count: int = 0


func enter() -> void:
	accept_trade.pressed.connect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "activate_trade")
	get_tree().call_group("SupplyResources", "disable")
	base.trade_panel.visible = true
	player = Player.LOCAL_PLAYER
	if player.num_cards <= 7:
		done_cutting()
	else:
		cut_target = floori(player.num_cards / 2.0)


func update(_delta: float) -> void:
	if done == false:
		cut_count = 0
		for i in 5:
			cut_count += player.trade_remove[i]
		if cut_count == cut_target:
			accept_trade.disabled = false
		else:
			accept_trade.disabled = true


func exit() -> void:
	players_ready = []
	accept_trade.disabled = true
	done = false


func done_cutting() -> void:
	done = true
	accept_trade.pressed.disconnect(_on_trade_accept_pressed)
	get_tree().call_group("PlayerResourceCards", "deactivate_trade")
	get_tree().call_group("SupplyResources", "enable")
	base.trade_panel.visible = false
	post_player_ready.rpc()


func _on_trade_accept_pressed() -> void:
	Player.LOCAL_PLAYER.trade_resources()
	done_cutting()


@rpc("any_peer", "call_local")
func post_player_ready() -> void:
	var id: int = multiplayer.get_remote_sender_id()
	if players_ready.has(id) == false:
		players_ready.append(id)
	if players_ready.size() == PlayerManager.GET_NUM_PLAYERS():
		if multiplayer.is_server():
			resume_turns.rpc(MatchManager.current_turn)


@rpc("authority", "call_local")
func resume_turns(turn: int) -> void:
	if player.turn_index == turn:
		state_changed.emit("RobberMoveState")
	else:
		state_changed.emit("InactiveState")
