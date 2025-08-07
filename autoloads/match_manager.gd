extends Node

var current_turn: int = 1
var current_round: int = 1


func _ready() -> void:
	EventTower.player_turn_ended.connect(_on_player_turn_ended)


func _on_player_turn_ended() -> void:
	current_turn += 1
	if current_turn > PlayerManager.GET_NUM_PLAYERS():
		current_turn = 1
		current_round += 1
	EventTower.player_turn_started.emit()
