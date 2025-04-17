class_name BuildingHotspot
extends Area3D

static var current_index: int = 0
static var num_hotspots: int = 0

@export var castle_holo: MeshInstance3D

var idx: int = -1

func _init() -> void:
	idx = current_index
	current_index += 1

func _on_area_entered(area: Area3D) -> void:
	if area is BuildingHotspot:
		if area.idx < idx:
			area.queue_free()
		else:
			queue_free()
