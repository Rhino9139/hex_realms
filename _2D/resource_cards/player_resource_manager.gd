extends Node2D

@export var type: TerrainType
@export var owned_stack: CardStack
@export var trade_stack: CardStack
@export var add_area: Area2D
@export var reduce_area: Area2D

var amount: int = 0
var trade_amount: int = 0

func _ready() -> void:
	owned_stack.type = type
	trade_stack.type = type

func _process(_delta: float) -> void:
	amount = Player.LOCAL_PLAYER.resources[type.index]
	owned_stack.refresh(amount - trade_amount)
	trade_stack.refresh(trade_amount)
	Player.LOCAL_PLAYER.trade_remove[type.index] = trade_amount

func activate_trade() -> void:
	trade_stack.visible = true
	add_area.collision_layer = 1
	reduce_area.collision_layer = 1

func deactivate_trade() -> void:
	trade_stack.visible = false
	add_area.collision_layer = 0
	reduce_area.collision_layer = 0
	trade_amount = 0

func _on_add_click_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			if amount - trade_amount > 0:
				trade_amount += 1

func _on_reduce_click_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			if trade_amount > 0:
				trade_amount -= 1
