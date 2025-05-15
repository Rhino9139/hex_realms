extends Node2D

@export var card_outer_1: Sprite2D
@export var card_inner_1: Sprite2D
@export var card_outer_2: Sprite2D
@export var card_inner_2: Sprite2D
@export var card_outer_3: Sprite2D
@export var card_inner_3: Sprite2D
@export var icon_1: Sprite2D
@export var icon_2: Sprite2D
@export var icon_3: Sprite2D
@export var amount_label: Label
@export var type: TerrainType

func _ready() -> void:
	card_inner_1.modulate = type.material.albedo_color
	card_inner_2.modulate = type.material.albedo_color
	card_inner_3.modulate = type.material.albedo_color
	icon_1.texture = type.icon_texture
	icon_2.texture = type.icon_texture
	icon_3.texture = type.icon_texture

func _process(_delta: float) -> void:
	refresh()

func refresh() -> void:
	var amount: int = Player.LOCAL_PLAYER.resources[type.index]
	amount_label.text = str(amount)
	if amount == 0:
		card_outer_1.modulate = Color(1.0, 1.0, 1.0, 0.25)
		card_outer_2.visible = false
		card_outer_3.visible = false
	elif amount == 1:
		card_outer_1.modulate = Color(1.0, 1.0, 1.0, 1.0)
		card_outer_2.visible = false
		card_outer_3.visible = false
	elif amount == 2:
		card_outer_1.modulate = Color(1.0, 1.0, 1.0, 1.0)
		card_outer_2.visible = true
		card_outer_3.visible = false
	elif amount >= 3:
		card_outer_1.modulate = Color(1.0, 1.0, 1.0, 1.0)
		card_outer_2.visible = true
		card_outer_3.visible = true
