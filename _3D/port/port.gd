class_name Port
extends Node3D

enum Type{BRICK, ORE, SHEEP, WHEAT, WOOD, POLY}

@export var idx: int = -1
@export var resource_sprite: Sprite3D

var type_res: TerrainType


func _ready() -> void:
	pass
