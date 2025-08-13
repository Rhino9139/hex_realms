class_name MatchLogic
extends Node

static var CURRENT_TURN: int = 1
static var CURRENT_ROUND: int = 1

var local_turn_index: int = 0

func _ready() -> void:
	Events.SCREEN_START.turn_order_created.connect(_turn_order_created)


func _turn_order_created() -> void:
	local_turn_index = Player.LOCAL_PLAYER.turn_index
	Events.HUD_END.add_hud.emit(HUD.Header.STANDARD)
	Events.HUD_END.add_player_cards.emit(PlayerManager.GET_PLAYERS())
	Events.LOGIC_DOWN.start_next_turn.emit(CURRENT_TURN, CURRENT_ROUND, local_turn_index)
