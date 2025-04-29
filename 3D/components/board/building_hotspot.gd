class_name BuildingHotspot
extends Area3D

static var current_index: int = 0
static var num_hotspots: int = 0

@export var settlement_holo: MeshInstance3D
@export var settlement_mesh: MeshInstance3D
@export var castle_holo: MeshInstance3D
@export var castle_mesh: MeshInstance3D
@export var hover_arrow: MeshInstance3D
@export var neighbor_area: Area3D
@export var animator: AnimationPlayer

var idx: int = -1
var neighbors: Array[BuildingHotspot] = []
var owner_number: int = -1

func _init() -> void:
	idx = current_index
	current_index += 1

func mouse_entered(hotspot_hovered: BuildingHotspot) -> void:
	if hotspot_hovered == self:
		hover_arrow.visible = true
		if animator.is_playing() == false:
			animator.play("hover")
	else:
		mouse_exited()

func mouse_exited() -> void:
	hover_arrow.visible = false
	animator.stop()

func area_clicked() -> void:
	$Settlement.visible = true

func get_neighbors() -> void:
	neighbor_area.monitoring = true
	await get_tree().create_timer(3.0).timeout
	neighbor_area.queue_free()
	collision_layer = 0
	collision_mask = 0

func buy_mode_entered(player_number: int, mode: String) -> void:
	if player_number != owner_number:
		return
	collision_layer = 1
	for child in get_children():
		if child is MeshInstance3D:
			child.visible = false
	match mode:
		"Settlement":
			settlement_holo.visible = true
		"Castle":
			castle_holo.visible = true

func buy_mode_exited() -> void:
	collision_layer = 0
	for child in get_children():
		if child is MeshInstance3D:
			child.visible = false

func _on_area_entered(area: Area3D) -> void:
	if area is BuildingHotspot:
		if area.idx < idx:
			area.queue_free()
		else:
			queue_free()

func _on_neighbor_area_area_entered(area: Area3D) -> void:
	if neighbors.has(area) == false and area != self:
		neighbors.append(area)
