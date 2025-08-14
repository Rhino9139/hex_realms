extends Node

@warning_ignore_start("unused_signal")
#3D Piece
signal robber_created
signal robber_moved
signal robber_steal_activated
signal robber_resource_stolen(target_player: Player)

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

signal points_changed
signal info_changed
signal resources_changed(player_id: int, resources: Array[int])
signal card_aquired(card_type: Global.ActionCardType)
signal card_used(card_type: Global.ActionCardType)

var GAME_START: GameStart = GameStart.new()
var GAME_END: GameEnd = GameEnd.new()
var PLAYER_START: PlayerStart = PlayerStart.new()
var PLAYER_END: PlayerEnd = PlayerEnd.new()
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
var LOGIC_UP: LogicUp = LogicUp.new()
var LOGIC_DOWN: LogicDown = LogicDown.new()


class GameStart:
	signal game_started


class GameEnd:
	signal change_local_name(new_name: String)


class PlayerStart:
	signal resources_changed(new_resources: Dictionary[Global.Resources, int], player_id: int)
	signal action_cards_changed(cards_in_hand: Array[Global.ActionCardType], cards_used: Array[Global.ActionCardType])


class PlayerEnd:
	signal buy_hotspot(hotspot_type: Hotspot.Type)


class CharacterStart:
	signal hotspot_hovered(new_hotspot: Hotspot)
	signal hotspot_clicked(player: Player)


class CharacterEnd:
	signal add_camera
	signal destroy_camera
	signal activate_camera
	signal deactivate_camera


class BoardStart:
	signal board_layout_generated
	signal board_destroyed
	signal board_added
	signal building_added(hotspot: Hotspot)


class BoardEnd:
	signal generate_board
	signal destroy_board
	signal add_board
	signal show_hover(message: Hotspot.Message)
	signal make_hotspot_available(message: Hotspot.Message)
	signal make_hotspot_unavailable
	signal click_hotspot(message: Hotspot.Message)
	signal gather_resources(roll: int)


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
	signal menu_changed(new_header: MenuManager.Header)
	signal match_started
	signal generate_board_requested
	signal destroy_board_requested


class MenuEnd:
	signal change_menu(new_header: MenuManager.Header)
	signal clear_menu
	signal enable_start_game
	signal disable_start_game


class HUDStart:
	signal buy_button_toggled_on(button_type: BuyButton.Type)
	signal buy_button_toggled_off
	signal roll_dice_requested
	signal end_turn_pressed


class HUDEnd:
	signal add_hud(new_header: HUD.Header)
	signal clear_hud
	signal toggle_buy_button_off
	signal disable_buy_button(button_type: BuyButton.Type)
	signal enable_buy_button
	signal add_player_cards(players: Array[Player])
	signal enable_dice_roll
	signal enable_end_turn
	signal update_last_roll(total: int)


class ScreenStart:
	signal turn_order_created
	signal dice_rolled(total: int)


class ScreenEnd:
	signal add_screen(new_header: Screen.Header, message: Screen.Message)
	signal clear_screen


class LogicUp:
	signal player_turn_finished


class LogicDown:
	signal start_next_turn(current_turn: int, current_round: int, LP_turn_index: int)
	signal go_to_standard
	signal go_to_inactive
