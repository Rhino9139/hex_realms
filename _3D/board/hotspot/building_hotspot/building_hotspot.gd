class_name BuildingHotspot
extends Hotspot

@export var settlement_mesh: Mesh
@export var castle_mesh: Mesh
@export var adjacent_buildings: Array[BuildingHotspot]
@export var adjacent_roads: Array[RoadHotspot]
@export var adjacent_hexes: Array[HexHotspot]
@export var port: Port

var player_owner: Player
var holo_mesh: MeshInstance3D
var upgrade_spot: Callable = build_settlement


func inner_ready() -> void:
	hotspot_type = Hotspot.Type.EMPTY


func get_resources() -> void:
	for hex in adjacent_hexes:
		if hex.terrain_type != Terrain.Type.DESERT:
			player_owner.change_resource(int(hex.terrain_type), 1)


func build_settlement(player_id: int) -> void:
	hotspot_type = Hotspot.Type.SETTLEMENT
	player_owner = PlayerManager.GET_PLAYER_BY_ID(player_id)
	
	main_model.set_surface_override_material(1, player_owner.player_mat)
	main_model.visible = true
	#if MatchLogic.CURRENT_ROUND == 2:
		#get_starting_resources()
	
	upgrade_spot = build_castle
	for building in adjacent_buildings:
		if is_instance_valid(building):
			building.queue_free()
	#TODO roads
	#TODO ports


func build_castle(_player_id: int) -> void:
	hotspot_type = Hotspot.Type.CASTLE
	player_owner.add_castle()
	#settlement_model.visible = false
	
	#castle_model.visible = true
	#castle_model.set_surface_override_material(0, castle_base_mat)
	#castle_model.set_surface_override_material(1, player_owner.player_mat)


func resource_rolled(type_index: int) -> void:
	if player_owner == null:
		return
	if hotspot_type == Hotspot.Type.SETTLEMENT:
		player_owner.change_resource(type_index, 1)
	elif hotspot_type == Hotspot.Type.CASTLE:
		player_owner.change_resource(type_index, 2)


func make_reachable() -> void:
	if player_owner == null:
		add_to_group("Empty")


func activate_hotspot(message: Message) -> void:
	build.rpc(message.player.player_id)
	if message.round_index == 2:
		get_resources()


@rpc("any_peer", "call_local")
func build(player_id: int) -> void:
	upgrade_spot.call(player_id)
	Events.BOARD_START.building_added.emit(self)
	#Events.add_building_exited.emit()
