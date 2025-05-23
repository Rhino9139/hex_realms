class_name Screen
extends Control

const _TURN_ROLL_PATH: String = "uid://ccs81bk4s65rk"
const _MONOPOLY_PATH: String = "uid://c1gixsxmqfk6c"
const _STEAL_PATH: String = "uid://c1la11wpv2w0f"
const _TRADE_PATH: String = "uid://ynnsk44tgphk"

static func CREATE_TURN_ROLL() -> void:
	var new_screen: Screen = load(_TURN_ROLL_PATH).instantiate()
	MasterGUI.ADD_SCREEN(new_screen)

static func CREATE_MONOPOLY_SCREEN() -> Screen:
	var new_screen: Screen = load(_MONOPOLY_PATH).instantiate()
	MasterGUI.ADD_SCREEN(new_screen)
	return new_screen

static func CREATE_STEAL_SCREEN(players: Array[Player]) -> Screen:
	var new_screen: Screen = load(_STEAL_PATH).instantiate()
	new_screen.players = players
	MasterGUI.ADD_SCREEN(new_screen)
	return new_screen

static func CREATE_TRADE_OFFER_SCREEN(trader_id: int, trader_give: Array[int], \
	trader_receive: Array[int]) -> void:
	var new_screen: Screen = load(_TRADE_PATH).instantiate()
	new_screen.trading_player_id = trader_id
	new_screen.trade_give = trader_give
	new_screen.trade_receive = trader_receive
	MasterGUI.ADD_SCREEN(new_screen)
