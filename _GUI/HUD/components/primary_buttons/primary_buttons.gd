extends Control


@export var roll_dice_button: Button
@export var end_turn_button: Button
@export var last_roll_label: Label


func _ready() -> void:
	Events.HUD_END.enable_dice_roll.connect(_enable_dice_roll)
	Events.HUD_END.enable_end_turn.connect(_enable_end_turn)
	Events.HUD_END.update_last_roll.connect(_update_last_roll)
	roll_dice_button.disabled = true
	end_turn_button.disabled = true


func _enable_dice_roll() -> void:
	roll_dice_button.disabled = false


func _enable_end_turn() -> void:
	end_turn_button.disabled = false


func _update_last_roll(_total: int) -> void:
	last_roll_label.text = str(_total)


func _on_roll_button_pressed() -> void:
	roll_dice_button.disabled = true
	Events.HUD_START.roll_dice_requested.emit()


func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.HUD_START.end_turn_pressed.emit()
