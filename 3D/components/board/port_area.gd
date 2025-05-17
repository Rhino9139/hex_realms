class_name PortArea
extends Area3D

@export var root_parent: Port

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	collision_layer = 0

func get_root() -> Port:
	return root_parent
