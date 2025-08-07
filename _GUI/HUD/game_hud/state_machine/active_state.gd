extends State

@export var supply_trade: Button
@export var action_card_confirm: Button
@export var player_trade: Button
@export var knight_card: Area2D
@export var point_card: Area2D
@export var monopoly_card: Area2D
@export var year_of_plenty: Area2D
@export var free_roads: Area2D


func enter() -> void:
	free_roads.clicked.connect(_on_free_roads_used)
	year_of_plenty.clicked.connect(_on_year_of_plenty_used)
	monopoly_card.clicked.connect(_on_monopoly_used)
	action_card_confirm.pressed.connect(_on_card_bought)
	point_card.clicked.connect(_on_point_used)
	knight_card.clicked.connect(_on_knight_used)
	supply_trade.toggled.connect(_on_supply_trade_toggled)
	player_trade.toggled.connect(_on_player_trade_started)
	base.turn_ended.connect(_on_turn_ended)
	Player.LOCAL_PLAYER.item_bought.connect(_on_item_bought)
	UIButton.ENABLE_UI()
	#Character.SWAP_TO_HOVER()
	base.end_turn_button.disabled = false
	base.end_turn_button.visible = true
	get_tree().call_group("BuyButton", "check_cost")
	get_tree().call_group("ActionCard", "activate")


func exit() -> void:
	free_roads.clicked.disconnect(_on_free_roads_used)
	year_of_plenty.clicked.disconnect(_on_year_of_plenty_used)
	monopoly_card.clicked.disconnect(_on_monopoly_used)
	action_card_confirm.pressed.disconnect(_on_card_bought)
	point_card.clicked.disconnect(_on_point_used)
	knight_card.clicked.disconnect(_on_knight_used)
	supply_trade.toggled.disconnect(_on_supply_trade_toggled)
	player_trade.toggled.disconnect(_on_player_trade_started)
	base.turn_ended.disconnect(_on_turn_ended)
	Player.LOCAL_PLAYER.item_bought.disconnect(_on_item_bought)
	UIButton.DISABLE_UI()
	base.end_turn_button.disabled = true
	base.end_turn_button.visible = false
	get_tree().call_group("ActionCard", "deactivate")


func update(_delta: float) -> void:
	get_tree().call_group("BuyButton", "check_cost")


func _on_item_bought(item: Global.BuyOption) -> void:
	match item:
		Global.BuyOption.SETTLEMENT:
			Player.LOCAL_PLAYER.pay_settlement()
		Global.BuyOption.CASTLE:
			Player.LOCAL_PLAYER.pay_castle()
		Global.BuyOption.ROAD:
			Player.LOCAL_PLAYER.pay_road()
		Global.BuyOption.CARD:
			Player.LOCAL_PLAYER.pay_card()
	get_tree().call_group("BuyButton", "check_cost")


func _on_knight_used() -> void:
	var player: Player = Player.LOCAL_PLAYER
	if player.knight_unused > 0:
		player.knight_unused -= 1
		player.knight_used += 1
		state_changed.emit("RobberMoveState")


func _on_point_used() -> void:
	pass


func _on_card_bought() -> void:
	for i in 5:
		Player.LOCAL_PLAYER.change_resource(i, -Global.CARD_COST[i])
	action_card_confirm.visible = false
	if multiplayer.is_server():
		server_get_card()
	else:
		request_action_card.rpc_id(1)


func _on_player_trade_started(toggled_on: bool) -> void:
	if toggled_on:
		state_changed.emit("PlayerTradeState")


func aquire_card(card_index: Global.ActionCardType) -> void:
	var player: Player = Player.LOCAL_PLAYER
	player


func _on_monopoly_used() -> void:
	var amount: int = Player.LOCAL_PLAYER.monopoly_cards
	if amount > 0:
		Player.LOCAL_PLAYER.monopoly_cards -= 1
		state_changed.emit("MonopolyState")


func _on_year_of_plenty_used() -> void:
	var amount: int = Player.LOCAL_PLAYER.year_of_plenty_cards
	if amount > 0:
		Player.LOCAL_PLAYER.year_of_plenty_cards -= 1
		state_changed.emit("YearOfPlentyState")


func _on_free_roads_used() -> void:
	var amount: int = Player.LOCAL_PLAYER.free_roads_cards
	var spots: int = get_tree().get_nodes_in_group("RoadEmpty").size()
	if amount > 0 and spots >= 2:
		Player.LOCAL_PLAYER.free_roads_cards -= 1
		state_changed.emit("FreeRoadsState")


func _on_turn_ended() -> void:
	state_changed.emit("InactiveState")


func _on_supply_trade_toggled(toggled_on: bool) -> void:
	if toggled_on:
		state_changed.emit("BankTradeState")


func server_get_card() -> void:
	var card_type: int = Global.ACTION_CARDS.pop_front()
	aquire_card(card_type)


@rpc("any_peer", "call_remote")
func request_action_card() -> void:
	var card_type: int = Global.ACTION_CARDS.pop_front()
	var player_id: int = multiplayer.get_remote_sender_id()
	respond_action_card.rpc_id(player_id, card_type)


@rpc("authority", "call_remote")
func respond_action_card(new_card: int) -> void:
	aquire_card(new_card)
