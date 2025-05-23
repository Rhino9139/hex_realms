extends Screen

@export var trader_label: Label
@export_group("Cards")
@export var give_brick_card: ResourceCard
@export var give_sheep_card: ResourceCard
@export var give_ore_card: ResourceCard
@export var give_wheat_card: ResourceCard
@export var give_wood_card: ResourceCard
@export_group("Amounts")
@export var give_brick_amount: Label
@export var give_sheep_amount: Label
@export var give_ore_amount: Label
@export var give_wheat_amount: Label
@export var give_wood_amount: Label
@export var receive_brick_amount: Label
@export var receive_sheep_amount: Label
@export var receive_ore_amount: Label
@export var receive_wheat_amount: Label
@export var receive_wood_amount: Label

var trading_player: Player
var trading_player_id: int
var trade_give: Array[int] 
var trade_receive: Array[int]

func _ready() -> void:
	trading_player = MultiplayerManager.GET_PLAYER(trading_player_id)
	trader_label.text = str(trading_player.player_name, " Gives Away:")
	give_brick_amount.text = str(trade_give[0])
	give_sheep_amount.text = str(trade_give[1])
	give_ore_amount.text = str(trade_give[2])
	give_wheat_amount.text = str(trade_give[3])
	give_wood_amount.text = str(trade_give[4])
	receive_brick_amount.text = str(trade_receive[0])
	receive_sheep_amount.text = str(trade_receive[1])
	receive_ore_amount.text = str(trade_receive[2])
	receive_wheat_amount.text = str(trade_receive[3])
	receive_wood_amount.text = str(trade_receive[4])

func _on_accept_offer_pressed() -> void:
	pass # Replace with function body.

func _on_decline_offer_pressed() -> void:
	queue_free()
