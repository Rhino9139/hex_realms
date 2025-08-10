extends Control

@export var timer_gradient: GradientTexture1D
@export var turn_progress_bar: TextureProgressBar
@export var roll_button: Button
@export var end_turn_button: Button
@export var player_card_parent: HBoxContainer
@export var turn_label: Label

var player: Player
var bar_tween: Tween
var current_turn_index: int = 0
var current_round_index: int = 0


func _ready() -> void:
	#add_player_cards()
	Events.player_turn_started.connect(_on_player_turn_started)
	Events.turn_finished.connect(_on_turn_finished)
	Events.roll_enabled.connect(_on_roll_enabled)


#func add_player_cards() -> void:
	#var player_list: Array = PlayerManager.GET_PLAYERS()
	#for i in player_list.size():
		#player_card_parent.add_child(PlayerCard.CREATE(player_list[i]))
	#for card in player_card_parent.get_children():
		#player_card_parent.move_child(card, card.player.turn_index - 1)


func auto_roll() -> void:
	roll_button.pressed.emit()


func _on_turn_finished() -> void:
	share_turn_ended.rpc()


func _on_roll_enabled() -> void:
	roll_button.disabled = false


func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	end_turn_button.visible = false
	_on_turn_finished()


func _on_roll_button_pressed() -> void:
	roll_button.disabled = true
	Events.roll_requested.emit()


func _on_player_turn_started() -> void:
	pass
	#var p: Player = PlayerManager.GET_PLAYER_BY_TURN(MatchManager.current_turn)
	#turn_label.text = "Current Turn: " + p.player_name


@rpc("any_peer", "call_local")
func share_turn_ended() -> void:
	Events.player_turn_ended.emit()
