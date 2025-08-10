class_name MatchLogic
extends Node

static var CURRENT_TURN: int = 1
static var CURRENT_ROUND: int = 1


func _ready() -> void:
	Events.player_turn_ended.connect(_on_player_turn_ended)


func _on_player_turn_ended() -> void:
	CURRENT_TURN += 1
	if CURRENT_TURN > PlayerManager.GET_NUM_PLAYERS():
		CURRENT_TURN = 1
		CURRENT_ROUND += 1
	Events.player_turn_started.emit()
