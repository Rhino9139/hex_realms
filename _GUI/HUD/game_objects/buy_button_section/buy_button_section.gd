extends Control

@export var confirm_buy_button: Button


func _ready() -> void:
	Events.HUD_END.enable_confirm_buy.connect(_enable_confirm_buy)
	Events.HUD_END.disable_confirm_buy.connect(_disable_confirm_buy)


func _enable_confirm_buy() -> void:
	confirm_buy_button.visible = true


func _disable_confirm_buy() -> void:
	confirm_buy_button.visible = false


func _on_confirm_buy_pressed() -> void:
	Events.HUD_START.card_buy_confirmed.emit()
	confirm_buy_button.visible = false
