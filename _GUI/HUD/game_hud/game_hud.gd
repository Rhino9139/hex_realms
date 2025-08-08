extends Control

@warning_ignore("unused_signal")
signal turn_ended

@export var timer_gradient: GradientTexture1D
@export var turn_progress_bar: TextureProgressBar
@export var roll_button: Button
@export var end_turn_button: Button
@export var player_card_parent: HBoxContainer
@export var turn_label: Label
@export_group("Buy Buttons")
@export var settlement_buy: Button
@export var castle_buy: Button
@export var road_buy: Button
@export var card_buy: Button

var player: Player
var bar_tween: Tween
var current_turn_index: int = 0
var current_round_index: int = 0


func _ready() -> void:
	#add_player_cards()
	Events.player_turn_started.connect(_on_player_turn_started)


#func add_player_cards() -> void:
	#var player_list: Array = PlayerManager.GET_PLAYERS()
	#for i in player_list.size():
		#player_card_parent.add_child(PlayerCard.CREATE(player_list[i]))
	#for card in player_card_parent.get_children():
		#player_card_parent.move_child(card, card.player.turn_index - 1)


func update_timer_progress(new_value: float) -> void:
	turn_progress_bar.value = new_value


func enable_roll() -> void:
	roll_button.disabled = false


func disable_roll() -> void:
	roll_button.disabled = true


func activate_timer_bar(new_time: float, type: String) -> void:
	turn_progress_bar.max_value = new_time
	if bar_tween:
		bar_tween.kill()
	bar_tween = create_tween()
	bar_tween.tween_method(update_timer_progress, new_time, 0.0, new_time)
	if type == "Roll":
		bar_tween.tween_callback(auto_roll)
	else:
		bar_tween.tween_callback(end_turn)


func disable_timer() -> void:
	if bar_tween:
		bar_tween.kill()


func auto_roll() -> void:
	roll_button.pressed.emit()


func end_turn() -> void:
	disable_timer()
	share_turn_ended.rpc()


func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	end_turn_button.visible = false
	end_turn()


func _on_player_turn_started() -> void:
	var p: Player = PlayerManager.GET_PLAYER_BY_TURN(MatchManager.current_turn)
	turn_label.text = "Current Turn: " + p.player_name


@rpc("any_peer", "call_local")
func share_turn_ended() -> void:
	Events.player_turn_ended.emit()
