class_name MatchLogic
extends Node

static var CURRENT_TURN: int = 1
static var CURRENT_ROUND: int = 1

var local_turn_index: int = 0
var num_players: int = 0


func _ready() -> void:
	Events.SCREEN_START.turn_order_created.connect(_turn_order_created)
	Events.LOGIC_UP.player_turn_finished.connect(_player_turn_finished)


func _turn_order_created() -> void:
	num_players = PlayerManager.GET_NUM_PLAYERS()
	local_turn_index = Player.LOCAL_PLAYER.turn_index
	Events.HUD_END.add_hud.emit(HUD.Header.STANDARD)
	Events.HUD_END.add_player_cards.emit(PlayerManager.GET_PLAYERS())
	Events.HUD_END.disable_buy_button.emit()
	Events.LOGIC_DOWN.start_next_turn.emit(CURRENT_TURN, CURRENT_ROUND, local_turn_index)


func _player_turn_finished() -> void:
	share_turn_start.rpc()


@rpc("any_peer", "call_local")
func share_turn_start() -> void:
	if CURRENT_ROUND == 1:
		advance_round_1()
	elif CURRENT_ROUND == 2:
		advance_round_2()
	else:
		advance_round_standard()
	Events.LOGIC_DOWN.start_next_turn.emit(CURRENT_TURN, CURRENT_ROUND, local_turn_index)


func advance_round_1() -> void:
	CURRENT_TURN += 1
	if CURRENT_TURN > num_players:
		CURRENT_TURN = num_players
		CURRENT_ROUND += 1


func advance_round_2() -> void:
	CURRENT_TURN -= 1
	if CURRENT_TURN == 0:
		CURRENT_TURN = 1
		CURRENT_ROUND += 1


func advance_round_standard() -> void:
	CURRENT_TURN += 1
	if CURRENT_TURN > num_players:
		CURRENT_TURN = 1
		CURRENT_ROUND += 1
