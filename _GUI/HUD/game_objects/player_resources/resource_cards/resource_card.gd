class_name ResourceCard
extends Panel

@export var resource_type: Global.Resources
@export var icon_sprite: TextureRect
@export var amount_label: Label

var empty_alpha: float = 0.10

func _ready() -> void:
	icon_sprite.texture = load(Global.RESOURCE_ICONS[resource_type])
	self_modulate = Global.RESOURCE_MATERIALS[resource_type].albedo_color
	modulate.a = empty_alpha
	Events.PLAYER_START.resources_changed.connect(_resources_changed)


func _resources_changed(resources: Dictionary[Global.Resources, int], player_id: int) -> void:
	if player_id != multiplayer.get_unique_id():
		return
	
	var amount: int = resources[resource_type]
	amount_label.text = str(amount)
	if amount == 0:
		modulate.a = empty_alpha
	else:
		modulate.a = 1.0
