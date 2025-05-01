class_name BuyButton
extends Button

@export_enum("Settlement", "Castle", "Road", "Card") var type: String

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().call_group("BuyButton", "buy_pressed", self)
		call(type)

func buy_pressed(new_buy: Button) -> void:
	if new_buy != self:
		set_pressed(false)

func Settlement() -> void:
	get_tree().call_group("Empty", "make_available", -1)

func Castle() -> void:
	pass

func Road() -> void:
	pass

func Card() -> void:
	pass
