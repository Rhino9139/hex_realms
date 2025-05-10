class_name GameHUD
extends Control

signal turn_started(round_index: int)
signal turn_ended()

const _PATH: String = "uid://dlysvvr1aprdc"

static var MASTER: GameHUD

@export var turn_progress_bar: TextureProgressBar
@export var roll_button: Button
@export var player_card_parent: HBoxContainer

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

func _init() -> void:
	MASTER = self

func _ready() -> void:
	pass

func add_player_cards() -> void:
	var player_list: Array = MultiplayerManager.RETURN_PLAYERS()
		
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
	turn_ended.emit()
	get_tree().call_group("BuyButton", "set_pressed", false)

@rpc("authority", "call_local")
func begin_new_turn(round_index: int) -> void:
	pass
