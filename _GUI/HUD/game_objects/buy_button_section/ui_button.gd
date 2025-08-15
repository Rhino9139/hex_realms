class_name BuyButton
extends Button

enum Type{SETTLEMENT, CASTLE, ROAD, CARD, BANK_TRADE, PLAYER_TRADE, ALL}

@export var button_type: Type

var cost: Dictionary


func _ready() -> void:
	toggled.connect(_on_toggled)
	cost = Global._COST_BY_BUTTON[button_type]
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


func _disable_buy_button() -> void:
	disabled = true


func _enable_buy_button() -> void:
	_check_cost()


func _check_cost() -> void:
	var LP_resources: Dictionary[Global.Resources, int] = Player.LOCAL_PLAYER.resources
	var can_buy: bool = true
	
	for i in 5:
		if LP_resources[i] < cost[i]:
			can_buy = false
	
	disabled = not can_buy
