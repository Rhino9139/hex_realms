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
var gather_mult: int = 0


func inner_ready() -> void:
	hotspot_type = Hotspot.Type.EMPTY
	Events.BOARD_END.gather_resources.connect(_gather_resources)


func _gather_resources(_roll: int = 0) -> void:
	if player_owner == null:
		return
	for hex in adjacent_hexes:
		if hex.has_robber == false:
			if hex.roll == _roll or _roll == 0:
				player_owner.change_resource(int(hex.terrain_type), gather_mult)


func has_availability(message: Message) -> bool:
	if message.round_index <= 2:
		return true
	for road in adjacent_roads:
		if road.player_owner == message.player:
			return true
	return false


func build_settlement(player_id: int) -> void:
	hotspot_type = Hotspot.Type.SETTLEMENT
	player_owner = PlayerManager.GET_PLAYER_BY_ID(player_id)
	gather_mult = 1
	
	main_model.set_surface_override_material(1, player_owner.player_mat)
	main_model.visible = true
	
	upgrade_spot = build_castle
	for building in adjacent_buildings:
		if is_instance_valid(building):
			building.queue_free()
	
	hover_model.mesh = castle_mesh
	
	#TODO ports


func build_castle(_player_id: int) -> void:
	hotspot_type = Hotspot.Type.CASTLE
	gather_mult = 2
	main_model.mesh = castle_mesh


func activate_hotspot(message: Message) -> void:
	build.rpc(message.player.player_id)
	if message.round_index == 2:
		_gather_resources()


@rpc("any_peer", "call_local")
func build(player_id: int) -> void:
	upgrade_spot.call(player_id)
	Events.BOARD_START.building_added.emit(self)
