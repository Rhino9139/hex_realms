class_name ResourceCard
extends Sprite2D

@export var inner_sprite: Sprite2D
@export var icon_sprite: Sprite2D

var type: TerrainType:
	set(new_value):
		type = new_value
		assign()

func assign() -> void:
	inner_sprite.modulate = type.material.albedo_color
	icon_sprite.texture = type.icon_texture

func show_unavailable() -> void:
	modulate = Color(1.0, 1.0, 1.0, 0.1)

func show_available() -> void:
	modulate = Color(1.0, 1.0, 1.0, 1.0)
