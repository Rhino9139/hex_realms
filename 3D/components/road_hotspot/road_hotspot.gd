class_name RoadHotspot
extends Area3D

static var current_index: int = 0
static var num_hotspots: int = 0

@export var road_model: MeshInstance3D
@export var indicator_model: MeshInstance3D

var idx: int = -1
var neighbors: Array[BuildingHotspot] = []
var owner_number: int = -1

func _init() -> void:
	idx = current_index
	current_index += 1

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	collision_mask = 0
	collision_layer = 0

func build() -> void:
	remove_from_group("RoadEmpty")
	make_unavailable()
	road_model.visible = true
	road_model.set_surface_override_material(0, Global.P1_MAT)

func make_available(_player_id: int) -> void:
	set_collision_layer_value(2, true)
	indicator_model.visible = true

func make_unavailable() -> void:
	set_collision_layer_value(2, false)
	indicator_model.visible = false
	hide_hover()

func show_hover() -> void:
	road_model.visible = true

func hide_hover() -> void:
	road_model.visible = false

func _on_area_entered(area: Area3D) -> void:
	if area is RoadHotspot:
		if area.idx < idx:
			area.queue_free()
		else:
			queue_free()
