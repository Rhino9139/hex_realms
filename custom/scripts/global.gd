class_name Global

const _SETTLEMENT: String = "Settlement"
const _CASTLE: String = "Castle"
const _ROAD: String = "Road"
const _CARD: String = "Card"

static var HOLO_MAT: ShaderMaterial = load("uid://cpvde0u8isi5h")

static var PLAYER_MATS: Dictionary[int, StandardMaterial3D] = {
	1 : load("uid://db6xyoo8kvsrv"),
	2 : load("uid://d1ba7go2vhy1k"),
	3 : load("uid://t2cj5x2ybelm"),
	4 : load("uid://dd6lp3tkgw0lc"),
}

static var TYPE_RES: Dictionary[int, TerrainType] = {
	0 : load("uid://03f6o1ggd8di"), #Brick
	1 : load("uid://brghdbk4jlcyo"), #Ore
	2 : load("uid://clhpnv8ji1oud"), #Sheep
	3 : load("uid://dxj3v0c7du1px"), #Wheat
	4 : load("uid://cvo8kw33xdrta"), #Wood
	5 : load("uid://bcuums3me4afe")
}

const ROLL_SPRITES: Dictionary = {
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

static var HEX_TYPES: Array[int] = [
	0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5
]

static var HEX_ROLLS: Array[int] = [
	2, 3, 3, 4, 4, 5, 5, 6, 6, 8, 8, 9, 9, 10, 10, 11, 11, 12
]

static var PORT_TYPES: Array[int] = [
	0, 1, 2, 3, 4, 5, 5, 5, 5
]

static var ACTION_CARD_TYPES: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,\
	1, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4]

static var SETTLEMENT_COST: Array[int] = [1, 0, 1, 1, 1]
static var CASTLE_COST: Array[int] = [0, 3, 0, 2, 0]
static var ROAD_COST: Array[int] = [1, 0, 0, 0, 1]
static var CARD_COST: Array[int] = [0, 1, 1, 1, 0]

static func MAKE_ROAD_FREE() -> void:
	ROAD_COST = [0, 0, 0, 0, 0]

static func MAKE_ROAD_COST() -> void:
	ROAD_COST = [1, 0, 0, 0, 1]
