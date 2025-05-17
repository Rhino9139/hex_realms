class_name GameHUD
extends Control

signal turn_started(turn_index: int, round_index: int)
signal turn_ended

const _PATH: String = "uid://dlysvvr1aprdc"

static var MASTER: GameHUD

@export var turn_progress_bar: TextureProgressBar
@export var roll_button: Button
@export var end_turn_button: Button
@export var player_card_parent: HBoxContainer
@export_group("Buy Buttons")
@export var settlement_buy: Button
@export var castle_buy: Button
@export var road_buy: Button
@export var card_buy: Button
@export_group("Trade")
@export var trade_panel: Panel


var player: Player
var bar_tween: Tween
var current_turn_index: int = 0
var current_round_index: int = 0

static func CREATE() -> GameHUD:
	var new_hud: GameHUD = load(_PATH).instantiate()
	return new_hud

static func DESTROY() -> void:
	MASTER.queue_free()

static func ADD_PLAYER_CARDS() -> void:
	MASTER.add_player_cards()
	if MASTER.multiplayer.is_server():
		MASTER.begin_new_turn.rpc(MASTER.current_turn_index, MASTER.current_round_index)

static func GET_ROUND_INDEX() -> int:
	return MASTER.current_round_index

func _init() -> void:
	MASTER = self

func _ready() -> void:
	for child in MultiplayerManager.RETURN_PLAYERS():
		if child.player_id == multiplayer.get_unique_id():
			player = child

func add_player_cards() -> void:
	var player_list: Array = MultiplayerManager.RETURN_PLAYERS()
	print(player_list)
	for i in player_list.size():
		player_card_parent.add_child(PlayerCard.CREATE(player_list[i]))

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
	turn_ended.emit()
	get_tree().call_group("BuyButton", "set_pressed", false)
	if multiplayer.is_server() == false:
		notify_turn_ended.rpc_id(1)
	else:
		notify_turn_ended()

#func update_resource_labels() -> void:
	#brick_label.text = str(Player.LOCAL_PLAYER.resources[0])
	#ore_label.text = str(Player.LOCAL_PLAYER.resources[1])
	#sheep_label.text = str(Player.LOCAL_PLAYER.resources[2])
	#wheat_label.text = str(Player.LOCAL_PLAYER.resources[3])
	#wood_label.text = str(Player.LOCAL_PLAYER.resources[4])

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	end_turn_button.visible = false
	end_turn()

@rpc("authority", "call_local")
func begin_new_turn(turn_index: int, round_index: int) -> void:
	current_turn_index = turn_index
	current_round_index = round_index
	get_tree().call_group("PlayerCard", "check_turn")
	if turn_index == player.turn_index:
		turn_started.emit(round_index)

@rpc("any_peer", "call_remote")
func notify_turn_ended() -> void:
	current_turn_index += 1
	if current_turn_index == MultiplayerManager.NUM_PLAYERS:
		current_turn_index = 0
		current_round_index += 1
	begin_new_turn.rpc(current_turn_index, current_round_index)
