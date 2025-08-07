class_name Port
extends Node3D

enum Type{BRICK, ORE, SHEEP, WHEAT, WOOD, POLY}

const RESOURCE_ICONS: Dictionary[Type, String] = {
	Type.BRICK : "uid://821wyrwyqror",
	Type.ORE : "uid://dvkktbdjnubnj",
	Type.SHEEP : "uid://dr44uvyhepawa",
	Type.WHEAT : "uid://ddayrfad1byx4",
	Type.WOOD : "uid://wrlvx80hbbkn",
	Type.POLY : "uid://ptowle3vxt7r",
}

static var PORT_ARRAY: Array[Type] = [
	Type.BRICK, Type.ORE, Type.SHEEP, Type.WHEAT, Type.WOOD, 
	Type.POLY, Type.POLY, Type.POLY, Type.POLY,
]
