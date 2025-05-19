class_name RoadHotspot
extends Area3D

static var current_index: int = 0
static var num_hotspots: int = 0

@export var road_model: MeshInstance3D
@export var indicator_model: MeshInstance3D
@export var neighbor_area: Area3D

var idx: int = -1
var neighbors: Array[Node3D] = []
var player: Player

func _init() -> void:
	idx = current_index
	current_index += 1

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	neighbor_area.queue_free()
	collision_layer = 0
	collision_mask = 0

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

func make_reachable() -> void:
	if player == null:
		add_to_group("RoadEmpty")

func _on_area_entered(area: Area3D) -> void:
	if area is RoadHotspot:
		if area.idx < idx:
			area.queue_free()
		else:
			queue_free()

func _on_neighbor_area_entered(area: Area3D) -> void:
	if area == self:
		return
	if neighbors.has(area) == false:
		neighbors.append(area)

@rpc("any_peer", "call_local")
func build(player_index: int) -> void:
	player = MultiplayerManager.RETURN_PLAYERS()[player_index]
	player.add_road()
	remove_from_group("RoadEmpty")
	if is_in_group("SetupRoads"):
		remove_from_group("SetupRoads")
	make_unavailable()
	road_model.visible = true
	var mat: StandardMaterial3D = player.player_mat
	road_model.set_surface_override_material(0, mat)
	get_tree().call_group("RoadEmpty", "make_unavailable")
	get_tree().call_group("SetupRoads", "make_unavailable")
	if player == Player.LOCAL_PLAYER:
		add_to_group("MyRoads")
		for i in neighbors:
			if is_instance_valid(i):
				i.make_reachable()
