class_name BuyButton
extends UIButton

static var SETUP_BUTTONS: Array[Button] = []

@export_enum("Settlement", "Castle", "Road", "Card") var type: String

var cost: Array[int] = []

static func ENABLE_SETUP() -> void:
	for i in SETUP_BUTTONS:
		i.disabled = false

static func DISABLE_SETUP() -> void:
	for i in SETUP_BUTTONS:
		i.disabled = true

func _ready() -> void:
	match type:
		"Settlement":
			cost = Global.SETTLEMENT_COST
			SETUP_BUTTONS.append(self)
		"Castle":
			cost = Global.CASTLE_COST
		"Road":
			cost = Global.ROAD_COST
			SETUP_BUTTONS.append(self)
		"Card":
			cost = Global.CARD_COST

func _on_toggled(toggled_on: bool) -> void:
	get_tree().call_group("Empty", "make_unavailable")
	get_tree().call_group("Settlement", "make_unavailable")
	get_tree().call_group("RoadEmpty", "make_unavailable")
	if toggled_on:
		get_tree().call_group("BuyButton", "buy_pressed", self)
		call(type)

func check_cost() -> void:
	if GameHUD.MASTER.current_turn_index != Player.LOCAL_PLAYER.turn_index:
		return
	var can_afford: bool = true
	disabled = false
	for i in 5:
		if cost[i] < Player.LOCAL_PLAYER.resources[i]:
			can_afford = false
	disabled = !can_afford

func buy_pressed(new_buy: Button) -> void:
	if new_buy != self:
		set_pressed(false)

func Settlement() -> void:
	if Player.LOCAL_PLAYER.settlement_credits == 1:
		get_tree().call_group("Empty", "make_available", -1)

func Castle() -> void:
	get_tree().call_group("Settlement", "make_available", -1)

func Road() -> void:
	if Player.LOCAL_PLAYER.road_credits == 1:
		get_tree().call_group("RoadEmpty", "make_available", -1)

func Card() -> void:
	pass
