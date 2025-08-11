extends Node

@warning_ignore_start("unused_signal")
signal game_opened
signal local_name_changed(new_name: String)
#3D Overview
signal generate_board_requested
signal board_generated
signal board_shared
signal add_board_requested
signal destroy_board_requested
signal player_activated
signal player_deactivated
#Networking
signal server_requested
signal server_created
signal server_destroyed
signal client_requested
signal client_created
signal client_destroyed
signal lobby_disconnected
#Match logic
signal host_match_started
signal match_started
signal turn_order_created
signal player_turn_ended
signal player_turn_started
signal turn_finished
#3D Piece
signal robber_created
signal robber_moved
signal robber_steal_activated
signal robber_resource_stolen(target_player: Player)
#UI HUD
signal player_ui_enabled
signal player_ui_disabled
signal type_chosen(type_index: int)
signal setup_entered
signal roll_enabled
signal roll_requested
signal dice_roll_completed(total: int)
signal monopoly_state_entered
signal bank_trade_started
signal bank_trade_completed
signal add_building_entered(building_type: Hotspot.Type)
signal add_building_exited
signal add_road_entered
signal add_road_exited

signal screen_task_completed

signal selectable_hovered(hovered_object: Hotspot)
signal settlement_built
signal road_built
signal item_bought(player_id: int, item: Global.BuyOption)

signal points_changed
signal info_changed
signal resources_changed(player_id: int, resources: Array[int])
signal card_aquired(card_type: Global.ActionCardType)
signal card_used(card_type: Global.ActionCardType)


var BOARD_START: BoardStart = BoardStart.new()
var BOARD_END: BoardEnd = BoardEnd.new()
var CHARACTER_START: CharacterStart = CharacterStart.new()
var CHARACTER_END: CharacterEnd = CharacterEnd.new()
var NETWORK_START: NetworkStart = NetworkStart.new()
var NETWORK_END: NetworkEnd = NetworkEnd.new()
var MENU_START: MenuStart = MenuStart.new()
var MENU_END: MenuEnd = MenuEnd.new()
var HUD_START: HUDStart = HUDStart.new()
var HUD_END: HUDEnd = HUDEnd.new()
var SCREEN_START: ScreenStart = ScreenStart.new()
var SCREEN_END: ScreenEnd = ScreenEnd.new()


class CharacterStart:
	pass


class CharacterEnd:
	signal add_camera
	signal destroy_camera
	signal activate_camera
	signal deactivate_camera


class BoardStart:
	signal board_generated
	signal board_destroyed


class BoardEnd:
	signal generate_board
	signal destroy_board


class NetworkStart:
	signal server_created
	signal server_destroyed
	signal client_created
	signal client_destroyed


class NetworkEnd:
	signal start_server
	signal stop_server
	signal start_client
	signal stop_client


class MenuStart:
	signal local_name_changed(new_name: String)
	signal host_game_pressed
	signal join_game_pressed
	signal lobby_exited
	signal menu_changed(new_header: Menu.Header)
	signal match_started
	signal generate_board_requested
	signal destroy_board_requested


class MenuEnd:
	signal change_menu(new_header: Menu.Header)
	signal clear_menu
	signal enable_start_game
	signal disable_start_game


class HUDStart:
	signal buy_button_toggled_on(button_type: BuyButton.Type)
	signal buy_button_toggled_off


class HUDEnd:
	signal add_hud(new_header: HUD.Header)
	signal clear_hud
	signal toggle_buy_button_off
	signal disable_buy_button(button_type: BuyButton.Type)
	signal enable_buy_button
	signal add_player_cards(players: Array[Player])


class ScreenStart:
	signal turn_order_created


class ScreenEnd:
	signal add_screen(new_header: Screen.Header)
	signal clear_screen
