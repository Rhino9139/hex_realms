class_name BuyButton
extends Button

enum Type{SETTLEMENT, CASTLE, ROAD, CARD, BANK_TRADE, PLAYER_TRADE, ALL}

@export var button_type: Type


func _ready() -> void:
	toggled.connect(_on_toggled)
	Events.HUD_END.toggle_buy_button_off.connect(_toggle_buy_button_off)
	Events.HUD_END.disable_buy_button.connect(_disable_buy_button)
	Events.HUD_END.enable_buy_button.connect(_enable_buy_button)


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Events.HUD_START.buy_button_toggled_on.emit(button_type)
	else:
		Events.HUD_START.buy_button_toggled_off.emit()


func _toggle_buy_button_off() -> void:
	button_pressed = false


func _disable_buy_button(b_type: BuyButton.Type) -> void:
	if b_type == Type.ALL:
		disabled = true
	elif b_type == button_type:
		disabled = true


func _enable_buy_button() -> void:
	disabled = false
