class_name BuyButton
extends UIButton

@export var confirm: Button
@export var has_cost: bool = false
@export var click_callable: Callable

func _ready() -> void:
	pass

func _on_toggled(toggled_on: bool) -> void:
	pass

func check_cost() -> void:
	var can_afford: bool = true
	var cost: Array[int]
	disabled = false
	for i in 5:
		if Player.LOCAL_PLAYER.resources[i] < cost[i]:
			can_afford = false
	disabled = !can_afford

func buy_pressed(new_buy: Button) -> void:
	if new_buy != self:
		set_pressed(false)

func Settlement() -> void:
	get_tree().call_group("Empty", "make_available", -1)

func Castle() -> void:
	get_tree().call_group("Settlement", "make_available", -1)

func Road() -> void:
	if MatchManager.current_round <= 2:
		get_tree().call_group("SetupRoads",  "make_available", -1)
	else:
		get_tree().call_group("RoadEmpty", "make_available", -1)

func Card() -> void:
	confirm.visible = true

func _on_confrim_pressed() -> void:
	set_pressed_no_signal(false)

func _on_build() -> void:
	set_pressed_no_signal(false)
