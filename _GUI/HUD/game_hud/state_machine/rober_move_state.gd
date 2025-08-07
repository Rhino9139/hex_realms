extends State


func enter() -> void:
	EventTower.robber_moved.connect(_on_robber_moved)
	#Character.SWAP_TO_HOVER()
	get_tree().call_group("Hex", "make_available")


func _on_robber_moved() -> void:
	get_tree().call_group("Hex", "make_unavailable")
	#Character.SWAP_T0_IDLE()
	var tradable: bool = false
	
	#TODO Steal card from new spot
	#var players: Array[Player] = HexRegion.ROBBER_HEX.get_neighbor_players()
	#for i in players:
		#if i == player:
			#players.erase(i)
	
	#if players.size() == 0:
		#finish_robber_move()
		#return
	#else:
		#for i in players:
			#if i.num_cards > 0:
				#tradable = true
	
	if tradable:
		EventTower.robber_steal_activated.emit()
		EventTower.robber_resource_stolen.connect(_on_resource_stolen)
	else:
		state_changed.emit("ActiveState")


func _on_resource_stolen(target_player: Player) -> void:
	print(target_player.player_name, " has been stolen from")
	var target_cards: Array[int]
	for i in 5:
		for j in target_player.resources[i]:
			target_cards.append(i)
	var chosen_card: int = target_cards.pick_random()
	Player.LOCAL_PLAYER.change_resource(chosen_card, 1)
	share_steal.rpc_id(target_player.player_id, chosen_card)
	state_changed.emit("ActiveState")


func exit() -> void:
	EventTower.robber_moved.disconnect(_on_robber_moved)
	EventTower.robber_resource_stolen.disconnect(_on_resource_stolen)


@rpc("any_peer", "call_remote")
func share_steal(type_index: int) -> void:
	Player.LOCAL_PLAYER.change_resource(type_index, -1)
