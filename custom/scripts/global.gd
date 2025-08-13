class_name Global

enum BuyOption{SETTLEMENT, CASTLE, ROAD, CARD}
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
const _BUY_OPTION_NAMES: Dictionary[Global.BuyOption, String] = {
	BuyOption.SETTLEMENT : "Settlement",
	BuyOption.CASTLE : "Castle",
	BuyOption.ROAD : "Road",
	BuyOption.CARD : "Card",
}
const _BUY_COST: Dictionary[Global.BuyOption, Array] = {
	BuyOption.SETTLEMENT : [1, 0, 1, 1, 1],
	BuyOption.CASTLE : [0, 3, 0, 2, 0],
	BuyOption.ROAD : [1, 0, 0, 0, 1],
	BuyOption.CARD : [0, 1, 1, 1, 0],
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

static var HOLO_MAT: ShaderMaterial = load("uid://cpvde0u8isi5h")
static var PLAYER_MATS: Dictionary[int, StandardMaterial3D] = {
	1 : load("uid://db6xyoo8kvsrv"),
	2 : load("uid://d1ba7go2vhy1k"),
	3 : load("uid://t2cj5x2ybelm"),
	4 : load("uid://dd6lp3tkgw0lc"),
}
static var HEX_ROLLS: Array[int] = [
	2, 3, 3, 4, 4, 5, 5, 6, 6, 8, 8, 9, 9, 10, 10, 11, 11, 12, 7
]

static var ACTION_CARDS: Array[int] = [
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4
	]
static var SETTLEMENT_COST: Array[int] = [1, 0, 1, 1, 1]
static var CASTLE_COST: Array[int] = [0, 3, 0, 2, 0]
static var ROAD_COST: Array[int] = [1, 0, 0, 0, 1]
static var CARD_COST: Array[int] = [0, 1, 1, 1, 0]


static func MAKE_ROAD_FREE() -> void:
	ROAD_COST = [0, 0, 0, 0, 0]


static func MAKE_ROAD_COST() -> void:
	ROAD_COST = [1, 0, 0, 0, 1]
