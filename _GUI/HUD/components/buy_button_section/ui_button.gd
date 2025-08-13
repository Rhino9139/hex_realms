class_name BuyButton
extends Button

enum Type{SETTLEMENT, CASTLE, ROAD, CARD, BANK_TRADE, PLAYER_TRADE, ALL}

const _BUY_COST: Dictionary[Type, Dictionary] = {
	Type.SETTLEMENT : {
		Global.Resources.BRICK : 1,
		Global.Resources.ORE : 0,
		Global.Resources.SHEEP : 1,
		Global.Resources.WHEAT : 1,
		Global.Resources.WOOD : 1,
		},
	Type.CASTLE : {
		Global.Resources.BRICK : 1,
		Global.Resources.ORE : 3,
		Global.Resources.SHEEP : 1,
		Global.Resources.WHEAT : 2,
		Global.Resources.WOOD : 1,
		},
	Type.ROAD : {
		Global.Resources.BRICK : 1,
		Global.Resources.ORE : 0,
		Global.Resources.SHEEP : 0,
		Global.Resources.WHEAT : 0,
		Global.Resources.WOOD : 1,
		},
	Type.CARD : {
		Global.Resources.BRICK : 0,
		Global.Resources.ORE : 1,
		Global.Resources.SHEEP : 1,
		Global.Resources.WHEAT : 1,
		Global.Resources.WOOD : 0,
		},
	Type.BANK_TRADE : {
		Global.Resources.BRICK : 0,
		Global.Resources.ORE : 0,
		Global.Resources.SHEEP : 0,
		Global.Resources.WHEAT : 0,
		Global.Resources.WOOD : 0,
		},
	Type.PLAYER_TRADE : {
		Global.Resources.BRICK : 0,
		Global.Resources.ORE : 0,
		Global.Resources.SHEEP : 0,
		Global.Resources.WHEAT : 0,
		Global.Resources.WOOD : 0,
		},
}

@export var button_type: Type

var cost: Dictionary


func _ready() -> void:
	toggled.connect(_on_toggled)
	cost = _BUY_COST[button_type]
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
	var LP_resources: Array[int] = Player.LOCAL_PLAYER.resources
	var can_buy: bool = true
	
	for i in 5:
		if LP_resources[i] < cost[i]:
			can_buy = false
	
	disabled = not can_buy
