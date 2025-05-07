class_name Port
extends Node3D

@export var idx: int = -1
@export var resource_sprite: Sprite3D

var type_res: TerrainType

func _ready() -> void:
	type_res = Global.TYPE_RES[Global.PORT_TYPES[idx]]
	resource_sprite.texture = type_res.icon_texture
