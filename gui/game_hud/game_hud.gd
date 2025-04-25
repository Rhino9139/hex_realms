class_name GameHUD
extends Control

const _PATH: String = "uid://dlysvvr1aprdc"

@export var turn_progress_bar: TextureProgressBar

static var MASTER: GameHUD

static func CREATE() -> GameHUD:
	var new_hud: GameHUD = load(_PATH).instantiate()
	return new_hud

static func DESTROY() -> void:
	MASTER.queue_free()

func _init() -> void:
	if MASTER != null:
		push_error("MORE THAN ONE GAME HUD FOR SOME REASON")
	MASTER = self

func move_turn_progress_bar() -> void:
	var tween: Tween = create_tween()
	tween.tween_method(update_progress, 60.0, 0.0, 60.0)

func update_progress(new_value: float) -> void:
	turn_progress_bar.value = new_value

func clear_focus() -> void:
	var focus_node: Control = get_viewport().gui_get_focus_owner()
	if focus_node:
		focus_node.release_focus()
		get_tree().call_group("BuyButton", "buy_pressed", null)
		get_tree().call_group("Hotspot", "buy_mode_exited")

func _on_roll_button_pressed() -> void:
	move_turn_progress_bar()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			clear_focus()
