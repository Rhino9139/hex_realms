class_name Global

static var HOLO_MAT: ShaderMaterial = load("uid://cpvde0u8isi5h")
static var P1_MAT: StandardMaterial3D = load("uid://db6xyoo8kvsrv")
static var P2_MAT: StandardMaterial3D = load("uid://d1ba7go2vhy1k")
static var P3_MAT: StandardMaterial3D = load("uid://t2cj5x2ybelm")
static var P4_MAT: StandardMaterial3D = load("uid://dd6lp3tkgw0lc")

static var TYPE_RES: Dictionary[int, TerrainType] = {
	0 : load("uid://03f6o1ggd8di"),
	1 : load("uid://brghdbk4jlcyo"),
	2 : load("uid://clhpnv8ji1oud"),
	3 : load("uid://dxj3v0c7du1px"),
	4 : load("uid://cvo8kw33xdrta"),
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
