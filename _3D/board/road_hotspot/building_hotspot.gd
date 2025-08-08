class_name BuildingHotspot
extends Area3D

enum Building{EMPTY, SETTLEMENT, CASTLE}

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
var player_owner: Player
var holo_mesh: MeshInstance3D
var current_building: Building = Building.EMPTY
var upgrade_spot: Callable = build_settlement


func _ready() -> void:
	Events.setup_entered.connect(_on_setup_entered)
	Events.selectable_hovered.connect(_on_selectable_hovered)
	
	settlement_model.set_surface_override_material(0, holo_mat)
	settlement_model.set_surface_override_material(1, holo_mat)


func starting_resources() -> void:
	for i in terrains:
		if i.type_res.index != 5:
			player_owner.change_resource(i.type_res.index, 1)


func build_settlement(player_id: int) -> void:
	current_building = Building.SETTLEMENT
	player_owner = PlayerManager.GET_PLAYER_BY_ID(player_id)
	print(player_id)
	print(player_owner)
	print(player_owner.player_mat)
	#if player_owner.settlement_count == 1:
		#starting_resources()
	#player.add_settlement()
	make_unavailable()
	
	settlement_model.visible = true
	var mat: StandardMaterial3D = player_owner.player_mat
	settlement_model.set_surface_override_material(0, null)
	settlement_model.set_surface_override_material(1, mat)
	upgrade_spot = build_castle
	for hotspot in neighbors:
		if is_instance_valid(hotspot):
			hotspot.queue_free()
	if player_owner == Player.LOCAL_PLAYER:
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
						if player_owner.trade_ratios[i] == 4:
							player_owner.trade_ratios[i] = 3
				else:
					player_owner.trade_ratios[ports[0].type_res.index] = 2


func build_castle(_player_id: int) -> void:
	current_building = Building.CASTLE
	player_owner.castle_built()
	settlement_model.visible = false
	castle_model.visible = true
	var mat: StandardMaterial3D = player_owner.player_mat
	castle_model.set_surface_override_material(0, castle_base_mat)
	castle_model.set_surface_override_material(1, mat)
	make_unavailable()
	if player_owner == Player.LOCAL_PLAYER:
		remove_from_group("Settlement")
		add_to_group("Castle")


func make_available(_player_id: int) -> void:
	available_indicator.visible = true
	collision_layer = 1


func make_unavailable() -> void:
	available_indicator.visible = false
	collision_layer = 0


func resource_rolled(type_index: int) -> void:
	if player_owner == null:
		return
	if current_building == Building.SETTLEMENT:
		player_owner.change_resource(type_index, 1)
	elif current_building == Building.CASTLE:
		player_owner.change_resource(type_index, 2)


func make_reachable() -> void:
	if player_owner == null:
		add_to_group("Empty")


func _on_setup_entered() -> void:
	available_indicator.visible = true
	collision_layer = 1


func _on_selectable_hovered(hovered_object: Node3D) -> void:
	if player_owner != null:
		return
	if hovered_object == self:
		settlement_model.visible = true
	else:
		settlement_model.visible = false


@rpc("any_peer", "call_local")
func build(player_id: int) -> void:
	upgrade_spot.call(player_id)
