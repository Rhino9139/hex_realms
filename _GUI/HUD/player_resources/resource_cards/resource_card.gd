class_name ResourceCard
extends Sprite2D

@export var inner_sprite: Sprite2D
@export var icon_sprite: Sprite2D
@export var type_index: int = -1

var type: TerrainType:
	set(new_value):
		type = new_value
		assign()


func _ready() -> void:
	if type_index != -1:
		get_type()


func assign() -> void:
	inner_sprite.modulate = type.material.albedo_color
	icon_sprite.texture = type.icon_texture


func show_unavailable() -> void:
	modulate = Color(1.0, 1.0, 1.0, 0.1)


func show_available() -> void:
	modulate = Color(1.0, 1.0, 1.0, 1.0)


func get_type() -> void:
	pass
