class_name UIButton
extends Button

enum Type{SETTLEMENT, CASTLE, ROAD, CARD, BANK_TRADE, PLAYER_TRADE}

@export var button_type: Type


func _ready() -> void:
	Events.player_turn_ended.connect(_on_player_turn_ended)


func _on_player_turn_ended() -> void:
	set_pressed_no_signal(false)
	disabled = true
