class_name CardStack
extends Node2D

@export var amount_label: Label
@export var card_1: ResourceCard
@export var card_2: ResourceCard
@export var card_3: ResourceCard

var type: TerrainType:
	set(new_value):
		type = new_value
		assign()

func assign() -> void:
	card_1.type = type
	card_2.type = type
	card_3.type = type

func refresh(amount: int) -> void:
	amount_label.text = str(amount)
	card_1.show_available()
	card_2.visible = false
	card_3.visible = false
	if amount == 0:
		card_1.show_unavailable()
	elif amount == 2:
		card_2.visible = true
	elif amount >= 3:
		card_2.visible = true
		card_3.visible = true
