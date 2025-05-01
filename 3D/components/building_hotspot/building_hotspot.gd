class_name BuildingHotspot
extends Area3D

static var current_index: int = 0
static var num_hotspots: int = 0

@export var neighbor_area: Area3D
@export var holo_mat: ShaderMaterial
@export var available_indicator: MeshInstance3D
@export var settlement_model: MeshInstance3D
@export var castle_model: MeshInstance3D
@export var castle_base_mat: StandardMaterial3D

var idx: int = -1
var neighbors: Array[BuildingHotspot] = []
var owner_number: int = -1
var upgrade_spot: Callable = build_settlement

func _init() -> void:
	idx = current_index
	current_index += 1

func get_neighbors() -> void:
	neighbor_area.monitoring = true
	await get_tree().create_timer(3.0).timeout
	neighbor_area.queue_free()
	collision_layer = 0
	collision_mask = 0

func build() -> void:
	upgrade_spot.call()

func build_settlement() -> void:
	add_to_group("Settlement")
	settlement_model.visible = true
	settlement_model.set_surface_override_material(1, null)
	#settlement_model.set_surface_override_material(1, null)
	upgrade_spot = build_castle

func build_castle() -> void:
	settlement_model.visible = false
	remove_from_group("Settlement")
	add_to_group("Castle")
	castle_model.visible = true
	castle_model.set_surface_override_material(0, castle_base_mat)
	#castle_model.set_surface_override_material(0, castle_base_mat)

func make_available(_player_id: int) -> void:
	available_indicator.visible = true
	collision_layer = 1

func make_unavailable() -> void:
	available_indicator.visible = false
	collision_layer = 0

func _on_area_entered(area: Area3D) -> void:
	if area is BuildingHotspot:
		if area.idx < idx:
			area.queue_free()
		else:
			queue_free()

func _on_neighbor_area_area_entered(area: Area3D) -> void:
	if neighbors.has(area) == false and area != self:
		neighbors.append(area)
