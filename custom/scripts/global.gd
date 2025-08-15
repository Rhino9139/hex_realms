class_name Global

enum ActionCardType{KNIGHT, VICTORY_POINT, YEAR_OF_PLENTY, MONOPOLY, FREE_ROADS}
enum Resources{BRICK, ORE, SHEEP, WHEAT, WOOD, POLY}

const RESOURCE_ICONS: Dictionary[Resources, String] = {
	Resources.BRICK : "uid://blocjyxlgcv2h",
	Resources.ORE : "uid://colijar1sm1j2",
	Resources.SHEEP : "uid://810o0ua6f4aw",
	Resources.WHEAT : "uid://7dfjrcsdk476",
	Resources.WOOD : "uid://fs12hyda4alo",
	Resources.POLY : "uid://blccv6dvu4j17",
}
const RESOURCE_MATERIALS: Dictionary[Resources, StandardMaterial3D] = {
	Resources.BRICK : preload("uid://ddftnmdjynn7l"),
	Resources.ORE : preload("uid://fq11bi1uisg1"),
	Resources.SHEEP : preload("uid://bjfuru3xc5v3e"),
	Resources.WHEAT : preload("uid://d1f3chw6ljd1r"),
	Resources.WOOD : preload("uid://b6tpt437kk0w6"),
}
const ROLL_SPRITES: Dictionary[int, String] = {
	2 : "uid://inbnixypi3tk",
	3 : "uid://j8fdr2h6cwu5",
	4 : "uid://c2jmh2t1cu0h3",
	5 : "uid://cfttawb76qe3e",
	6 : "uid://7o60gldaqdos",
	7 : "uid://belk0wx2qdv7a",
	8 : "uid://b7vue37l6nkl5",
	9 : "uid://5pqc43q65d6k",
	10 : "uid://rbdxc5l4kkq0",
	11 : "uid://kgyvvllfe603",
	12 : "uid://qpsusqjkfbux",
}
const _SETTLEMENT_COST: Dictionary[Global.Resources, int] = {
	Global.Resources.BRICK : 1,
	Global.Resources.ORE : 0,
	Global.Resources.SHEEP : 1,
	Global.Resources.WHEAT : 1,
	Global.Resources.WOOD : 1,
}
const _CASTLE_COST: Dictionary[Global.Resources, int] = {
	Global.Resources.BRICK : 0,
	Global.Resources.ORE : 3,
	Global.Resources.SHEEP : 0,
	Global.Resources.WHEAT : 2,
	Global.Resources.WOOD : 0,
}
const _ROAD_COST: Dictionary[Global.Resources, int] = {
	Global.Resources.BRICK : 1,
	Global.Resources.ORE : 0,
	Global.Resources.SHEEP : 0,
	Global.Resources.WHEAT : 0,
	Global.Resources.WOOD : 1,
}
const _CARD_COST: Dictionary[Global.Resources, int] = {
	Global.Resources.BRICK : 0,
	Global.Resources.ORE : 1,
	Global.Resources.SHEEP : 1,
	Global.Resources.WHEAT : 1,
	Global.Resources.WOOD : 0,
}
const _TRADE_COST: Dictionary[Global.Resources, int] = {
	Global.Resources.BRICK : 0,
	Global.Resources.ORE : 0,
	Global.Resources.SHEEP : 0,
	Global.Resources.WHEAT : 0,
	Global.Resources.WOOD : 0,
}
const _COST_BY_HOTSPOT: Dictionary[Hotspot.Type, Dictionary] = {
	Hotspot.Type.EMPTY : _SETTLEMENT_COST,
	Hotspot.Type.SETTLEMENT : _CASTLE_COST,
	Hotspot.Type.ROAD : _ROAD_COST,
}
const _COST_BY_BUTTON: Dictionary[BuyButton.Type, Dictionary] = {
	BuyButton.Type.SETTLEMENT : _SETTLEMENT_COST,
	BuyButton.Type.CASTLE : _CASTLE_COST,
	BuyButton.Type.ROAD : _ROAD_COST,
	BuyButton.Type.CARD : _CARD_COST,
	BuyButton.Type.BANK_TRADE : _TRADE_COST,
	BuyButton.Type.PLAYER_TRADE : _TRADE_COST,
}
const _ACTION_CARD_COLORS: Dictionary[ActionCardType, Color] = {
	ActionCardType.KNIGHT : Color.DIM_GRAY,
	ActionCardType.VICTORY_POINT : Color.SEA_GREEN,
	ActionCardType.YEAR_OF_PLENTY : Color.YELLOW,
	ActionCardType.MONOPOLY : Color.ROYAL_BLUE,
	ActionCardType.FREE_ROADS : Color.ORANGE_RED,
}

static var HOLO_MAT: ShaderMaterial = load("uid://cpvde0u8isi5h")
static var PLAYER_MATS: Dictionary[int, StandardMaterial3D] = {
	1 : load("uid://db6xyoo8kvsrv"),
	2 : load("uid://d1ba7go2vhy1k"),
	3 : load("uid://t2cj5x2ybelm"),
	4 : load("uid://dd6lp3tkgw0lc"),
}
static var HEX_ROLLS: Array[int] = [
	2, 3, 3, 4, 4, 5, 5, 6, 6, 8, 8, 9, 9, 10, 10, 11, 11, 12,
]
static var ACTION_CARDS: Array[ActionCardType] = [
	ActionCardType.KNIGHT, ActionCardType.KNIGHT, ActionCardType.KNIGHT,
	ActionCardType.KNIGHT, ActionCardType.KNIGHT, ActionCardType.KNIGHT,
	ActionCardType.KNIGHT, ActionCardType.KNIGHT, ActionCardType.KNIGHT,
	ActionCardType.KNIGHT, ActionCardType.KNIGHT, ActionCardType.KNIGHT,
	ActionCardType.KNIGHT, ActionCardType.KNIGHT, 
	ActionCardType.VICTORY_POINT, ActionCardType.VICTORY_POINT, ActionCardType.VICTORY_POINT,
	ActionCardType.VICTORY_POINT, ActionCardType.VICTORY_POINT,
	ActionCardType.YEAR_OF_PLENTY, ActionCardType.YEAR_OF_PLENTY,
	ActionCardType.MONOPOLY, ActionCardType.MONOPOLY,
	ActionCardType.FREE_ROADS, ActionCardType.FREE_ROADS,
	]
