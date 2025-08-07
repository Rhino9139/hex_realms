extends Node

@warning_ignore_start("unused_signal")
signal game_opened
signal local_name_changed(new_name: String)

signal generate_board_requested
signal board_generated
signal board_shared
signal add_board_requested
signal destroy_board_requested
signal camera_activated
signal camera_deactivated

signal host_match_started
signal match_started
signal turn_order_created

signal server_requested
signal client_requested
signal server_created
signal server_destroyed
signal client_created
signal client_destroyed
signal lobby_disconnected

signal player_turn_ended
signal player_turn_started

signal robber_created
signal robber_moved
signal robber_steal_activated
signal robber_resource_stolen(target_player: Player)

signal type_chosen(type_index: int)
signal monopoly_state_entered
signal bank_trade_started
signal bank_trade_completed

signal selectable_hovered(hovered_object: Node3D)

signal settlement_built
signal road_built
signal item_bought(player_id: int, item: Global.BuyOption)
signal points_changed
signal info_changed
signal resources_changed(player_id: int, resources: Array[int])
signal card_aquired(card_type: Global.ActionCardType)
signal card_used(card_type: Global.ActionCardType)
