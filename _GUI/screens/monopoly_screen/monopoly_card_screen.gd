extends Screen

signal type_chosen(type_index: int)

@export var brick_card: Sprite2D
@export var ore_card: Sprite2D
@export var sheep_card: Sprite2D
@export var wheat_card: Sprite2D
@export var wood_card: Sprite2D
@export var confirm_outline: Sprite2D

var base_pos: Vector2 = Vector2(476.0, 299.0)
var chosen_type: int = 0

func _ready() -> void:
	brick_card.type = Global.TYPE_RES[0]
	ore_card.type = Global.TYPE_RES[1]
	sheep_card.type = Global.TYPE_RES[2]
	wheat_card.type = Global.TYPE_RES[3]
	wood_card.type = Global.TYPE_RES[4]

func _on_confirm_pressed() -> void:
	type_chosen.emit(chosen_type)
	queue_free()

func _on_area_clicked(_viewport: Node, event: InputEvent, _shape_idx: int, \
	type_index: int) -> void:
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			chosen_type = type_index
			confirm_outline.global_position.x = 476.0 + (50.0 * type_index)
