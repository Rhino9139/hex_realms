extends Node2D

@export var amount_label: Label

func _process(_delta: float) -> void:
	var amount: int = Player.LOCAL_PLAYER.point_card_used
	amount_label.text = str(amount)
	if amount == 0:
		modulate = Color(1.0, 1.0, 1.0, 0.1)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
