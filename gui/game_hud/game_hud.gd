class_name GameHUD
extends Control

signal turn_ended()

const _PATH: String = "uid://dlysvvr1aprdc"

static var MASTER: GameHUD

@export var turn_progress_bar: TextureProgressBar
@export var roll_button: Button
@export_group("Player Labels")
@export var p1_label: Label
@export var p2_label: Label
@export var p3_label: Label
@export var p4_label: Label

var bar_tween: Tween

static func CREATE() -> GameHUD:
	var new_hud: GameHUD = load(_PATH).instantiate()
	return new_hud

static func DESTROY() -> void:
	MASTER.queue_free()

func _init() -> void:
	MASTER = self

func _ready() -> void:
	p1_label.modulate = Global.P1_MAT.albedo_color
	p2_label.modulate = Global.P2_MAT.albedo_color
	p3_label.modulate = Global.P3_MAT.albedo_color
	p4_label.modulate = Global.P4_MAT.albedo_color

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
