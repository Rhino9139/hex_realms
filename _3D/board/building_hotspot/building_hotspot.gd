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

var idx: int = 0
var neighbors: Array[BuildingHotspot] = []
var roads: Array[RoadHotspot] = []
var terrains: Array[HexRegion] = []
var ports: Array[Port] = []
var player: Player
var upgrade_spot: Callable = build_settlement
var holo_mesh: MeshInstance3D
var current_building: String = "Empty"


func _init() -> void:
	idx = current_index
	current_index += 1


func _ready() -> void:
	settlement_model.set_surface_override_material(0, holo_mat)
	settlement_model.set_surface_override_material(1, holo_mat)
	await get_tree().create_timer(2.0).timeout
	neighbor_area.queue_free()
	collision_layer = 0
	collision_mask = 0


func starting_resources() -> void:
	for i in terrains:
		if i.type_res.index != 5:
			player.change_resource(i.type_res.index, 1)


func build_settlement(player_id: int) -> void:
	current_building = "Settlement"
	player = PlayerManager.GET_PLAYER_BY_ID(player_id)
	if player.settlement_count == 1:
		starting_resources()
	player.add_settlement()
	make_unavailable()
	remove_from_group("Empty")
	settlement_model.visible = true
	var mat: StandardMaterial3D = player.player_mat
	settlement_model.set_surface_override_material(0, null)
	settlement_model.set_surface_override_material(1, mat)
	upgrade_spot = build_castle
	for i in neighbors:
		if is_instance_valid(i):
			i.queue_free()
	if player == Player.LOCAL_PLAYER:
		add_to_group("Settlement")
		if MatchManager.current_round <= 2:
			for i in roads:
				if is_instance_valid(i):
					i.add_to_group("SetupRoads")
		if ports.size() > 0:
			if is_instance_valid(ports[0]):
				var port_index: int = ports[0].type_res.index
				if port_index == 5:
					for i in 5:
						if player.trade_ratios[i] == 4:
							player.trade_ratios[i] = 3
				else:
					player.trade_ratios[ports[0].type_res.index] = 2


func build_castle(_player_id: int) -> void:
	current_building = "Castle"
	player.castle_built()
	settlement_model.visible = false
	castle_model.visible = true
	var mat: StandardMaterial3D = player.player_mat
	castle_model.set_surface_override_material(0, castle_base_mat)
	castle_model.set_surface_override_material(1, mat)
	make_unavailable()
	if player == Player.LOCAL_PLAYER:
		remove_from_group("Settlement")
		add_to_group("Castle")


func make_available(_player_id: int) -> void:
	available_indicator.visible = true
	collision_layer = 1


func make_unavailable() -> void:
	available_indicator.visible = false
	collision_layer = 0


func show_hover() -> void:
	settlement_model.visible = true


func hide_hover() -> void:
	settlement_model.visible = false


func resource_rolled(type_index: int) -> void:
	if player == null:
		return
	if current_building == "Settlement":
		player.change_resource(type_index, 1)
	elif current_building == "Castle":
		player.change_resource(type_index, 2)


func make_reachable() -> void:
	if player == null:
		add_to_group("Empty")


func _on_area_entered(area: Area3D) -> void:
	if area is BuildingHotspot:
		if area.idx < idx:
			area.queue_free()
		else:
			queue_free()


func _on_neighbor_area_area_entered(area: Area3D) -> void:
	if area is BuildingHotspot:
		if neighbors.has(area) == false and area != self:
			neighbors.append(area)
	elif area is RoadHotspot:
		if roads.has(area) == false:
			roads.append(area)
	elif area is HexRegion:
		area.add_build_spot(self)
		if terrains.has(area) == false:
			terrains.append(area)



@rpc("any_peer", "call_local")
func build(player_id: int) -> void:
	upgrade_spot.call(player_id)
	get_tree().call_group("BuyButton", "buy_pressed", null)
	if is_in_group("Empty"):
		remove_from_group("Empty")
	
