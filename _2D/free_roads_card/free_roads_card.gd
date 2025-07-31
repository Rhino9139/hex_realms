extends Area2D

signal clicked

@export var amount_label: Label


func _process(_delta: float) -> void:
	var amount: int = Player.LOCAL_PLAYER.free_roads_cards
	amount_label.text = str(amount)
	if amount == 0:
		modulate = Color(1.0, 1.0, 1.0, 0.1)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)


func activate() -> void:
	collision_layer = 1


func deactivate() -> void:
	collision_layer = 0


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			clicked.emit()
