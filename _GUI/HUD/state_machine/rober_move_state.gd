extends State

var player: Player
var screen: Screen

func enter() -> void:
	EventBus.robber_moved.connect(_on_robber_moved)
	Character.SWAP_TO_HOVER()
	get_tree().call_group("Hex", "make_available")
	player = Player.LOCAL_PLAYER

func _on_robber_moved() -> void:
	get_tree().call_group("Hex", "make_unavailable")
	EventBus.robber_moved.disconnect(_on_robber_moved)
	Character.SWAP_T0_IDLE()
	var tradable: bool = false
	var players: Array[Player] = HexRegion.ROBBER_HEX.get_neighbor_players()
	for i in players:
		if i == player:
			players.erase(i)
	if players.size() == 0:
		finish_robber_move()
		return
	else:
		for i in players:
			if i.num_cards > 0:
				tradable = true
	if tradable:
		EventBus.robber_steal_activated.emit()
		#screen = Screen.CREATE_STEAL_SCREEN(players)
		
		EventBus.robber_resource_stolen.connect(_on_resource_stolen)
		#screen.resource_stolen.connect(_on_resource_stolen)
	else:
		finish_robber_move()

func _on_resource_stolen(target_player: Player) -> void:
	print(target_player.player_name, " has been stolen from")
	var target_cards: Array[int]
	for i in 5:
		for j in target_player.resources[i]:
			target_cards.append(i)
	var chosen_card: int = target_cards.pick_random()
	Player.LOCAL_PLAYER.change_resource(chosen_card, 1)
	share_steal.rpc_id(target_player.player_id, chosen_card)
	finish_robber_move()

func finish_robber_move() -> void:
	state_changed.emit("ActiveState")

@rpc("any_peer", "call_remote")
func share_steal(type_index: int) -> void:
	Player.LOCAL_PLAYER.change_resource(type_index, -1)
