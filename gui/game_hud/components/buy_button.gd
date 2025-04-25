extends Button

@export var type: String

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().call_group("BuyButton", "buy_pressed", self)
		
		get_tree().call_group("Hotspot", "buy_mode_entered", -1, type)

func buy_pressed(new_buy: Button) -> void:
	if new_buy != self:
		set_pressed(false)
