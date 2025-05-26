extends Node2D

@export var type: TerrainType
@export var owned_stack: CardStack
@export var trade_stack: CardStack

var amount: int = 20
var trade_amount: int = 0

func _ready() -> void:
	owned_stack.type = type
	trade_stack.type = type

func _process(_delta: float) -> void:
	if visible:
		owned_stack.refresh(amount - trade_amount)
		trade_stack.refresh(trade_amount)
		Player.LOCAL_PLAYER.trade_add[type.index] = trade_amount

func disable() -> void:
	visible = false

func enable() -> void:
	visible = true

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

func _on_visibility_changed() -> void:
	trade_amount = 0
