class_name ResourceCard
extends Panel

@export var resource_type: Global.Resources
@export var icon_sprite: TextureRect
@export var amount_label: Label


func _ready() -> void:
	icon_sprite.texture = load(Global.RESOURCE_ICONS[resource_type])
	self_modulate = Global.RESOURCE_MATERIALS[resource_type].albedo_color
	Events.resources_changed.connect(_on_resources_changed)


func _on_resources_changed(player_id: int, resources: Array[int]) -> void:
	if player_id != multiplayer.get_unique_id():
		return
	
	var amount: int = resources[resource_type]
	amount_label.text = str(amount)
