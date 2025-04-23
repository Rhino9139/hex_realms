class_name BuildingHotspot
extends Area3D

static var current_index: int = 0
static var num_hotspots: int = 0

@export var castle_holo: MeshInstance3D
@export var hover_indicator: GPUParticles3D
@export var neighbor_area: Area3D

var idx: int = -1
var neighbors: Array[BuildingHotspot] = []

func _init() -> void:
	idx = current_index
	current_index += 1

func mouse_entered(hotspot_hovered: BuildingHotspot) -> void:
	if hotspot_hovered == self:
		hover_indicator.emitting = true
		hover_indicator.visible = true
		castle_holo.visible = true
	else:
		mouse_exited()

func mouse_exited() -> void:
	hover_indicator.emitting = false
	hover_indicator.visible = false
	castle_holo.visible = false

func area_clicked() -> void:
	$Settlement.visible = true

func get_neighbors() -> void:
	neighbor_area.monitoring = true
	await get_tree().create_timer(3.0).timeout
	neighbor_area.queue_free()

func _on_area_entered(area: Area3D) -> void:
	if area is BuildingHotspot:
		if area.idx < idx:
			area.queue_free()
		else:
			queue_free()

func _on_neighbor_area_area_entered(area: Area3D) -> void:
	if neighbors.has(area) == false and area != self:
		neighbors.append(area)
