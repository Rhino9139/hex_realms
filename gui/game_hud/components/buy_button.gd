class_name BuyButton
extends UIButton

@export_enum("Settlement", "Castle", "Road", "Card") var type: String

func _on_toggled(toggled_on: bool) -> void:
	get_tree().call_group("Empty", "make_unavailable")
	get_tree().call_group("Settlement", "make_unavailable")
	get_tree().call_group("RoadEmpty", "make_unavailable")
	if toggled_on:
		get_tree().call_group("BuyButton", "buy_pressed", self)
		call(type)

func buy_pressed(new_buy: Button) -> void:
	if new_buy != self:
		set_pressed(false)

func Settlement() -> void:
	get_tree().call_group("Empty", "make_available", -1)

func Castle() -> void:
	get_tree().call_group("Settlement", "make_available", -1)

func Road() -> void:
	get_tree().call_group("RoadEmpty", "make_available", -1)

func Card() -> void:
	pass
