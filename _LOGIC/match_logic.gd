class_name MatchLogic
extends Node

var CURRENT_TURN: int = 1
var CURRENT_ROUND: int = 1


func _ready() -> void:
	Events.SCREEN_START.turn_order_created.connect(_turn_order_created)


func _turn_order_created() -> void:
	Events.HUD_END.add_hud.emit(HUD.Header.STANDARD)
	Events.HUD_END.add_player_cards.emit(PlayerManager.GET_PLAYERS())
