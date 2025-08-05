@icon("uid://dpj2qc1y3bryf")
class_name Terrain
extends Node3D

enum Type{BRICK, ORE, SHEEP, WHEAT, WOOD, DESERT}

const _TYPE_NAMES: Dictionary[Type, String] = {
	Type.BRICK : "Brick",
	Type.ORE : "Ore",
	Type.SHEEP : "Sheep",
	Type.WHEAT : "Wheat",
	Type.WOOD : "Wood",
	Type.DESERT : "Desert",
}
const _SCENES: Dictionary[Type, PackedScene] = {
	Type.BRICK : preload("uid://bdxeiyt4fltk8"),
	Type.ORE : preload("uid://tcs871fcwdsa"),
	Type.SHEEP : preload("uid://c61bjrs5f08w6"),
	Type.WHEAT : preload("uid://cxbdpnlc2b1rm"),
	Type.WOOD : preload("uid://e81sacjtusa"),
	Type.DESERT : preload("uid://bocaxmwxgyws5"),
}

static var TYPE_ARRAY: Array[Type] = [
	Type.BRICK, Type.BRICK, Type.BRICK, Type.ORE, Type.ORE, Type.ORE,
	Type.SHEEP, Type.SHEEP, Type.SHEEP, Type.SHEEP,
	Type.WHEAT, Type.WHEAT, Type.WHEAT, Type.WHEAT,
	Type.WOOD, Type.WOOD, Type.WOOD, Type.WOOD,
]
