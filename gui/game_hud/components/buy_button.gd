class_name BuyButton
extends UIButton

static var SETTLEMENT_BUY: BuyButton
static var ROAD_BUY: BuyButton

@export_enum("Settlement", "Castle", "Road", "Card") var type: String

var cost: Array[int] = []

static func ENABLE_SETTLEMENT() -> void:
	SETTLEMENT_BUY.disabled = false

static func ENABLE_ROAD() -> void:
	ROAD_BUY.disabled = false

static func DISABLE_SETTLEMENT() -> void:
	SETTLEMENT_BUY.disabled = true

static func DISABLE_ROAD() -> void:
	ROAD_BUY.disabled = true

func _ready() -> void:
	match type:
		"Settlement":
			cost = Global.SETTLEMENT_COST
			SETTLEMENT_BUY = self
		"Castle":
			cost = Global.CASTLE_COST
		"Road":
			cost = Global.ROAD_COST
			ROAD_BUY = self
		"Card":
			cost = Global.CARD_COST

func _on_toggled(toggled_on: bool) -> void:
	get_tree().call_group("Empty", "make_unavailable")
	get_tree().call_group("Settlement", "make_unavailable")
	get_tree().call_group("RoadEmpty", "make_unavailable")
	get_tree().call_group("SetupRoads", "make_unavailable")
	if toggled_on:
		get_tree().call_group("BuyButton", "buy_pressed", self)
		call(type)

func check_cost() -> void:
	var can_afford: bool = true
	disabled = false
	for i in 5:
		if Player.LOCAL_PLAYER.resources[i] < cost[i]:
			can_afford = false
	disabled = !can_afford
	print(name, " ", can_afford)

func buy_pressed(new_buy: Button) -> void:
	if new_buy != self:
		set_pressed(false)

func Settlement() -> void:
	get_tree().call_group("Empty", "make_available", -1)

func Castle() -> void:
	get_tree().call_group("Settlement", "make_available", -1)

func Road() -> void:
	if GameHUD.GET_ROUND_INDEX() <= 1:
		get_tree().call_group("SetupRoads",  "make_available", -1)
	else:
		get_tree().call_group("RoadEmpty", "make_available", -1)

func Card() -> void:
	pass
