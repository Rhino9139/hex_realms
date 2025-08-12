class_name BuildingHotspot
extends Hotspot

@export var holo_mat: ShaderMaterial
@export var available_indicator: MeshInstance3D
@export var settlement_model: MeshInstance3D
@export var castle_model: MeshInstance3D
@export var castle_base_mat: StandardMaterial3D
@export var adjacent_buildings: Array[BuildingHotspot]
@export var adjacent_roads: Array[RoadHotspot]
@export var adjacent_hexes: Array[HexHotspot]
@export var port: Port

var player_owner: Player
var holo_mesh: MeshInstance3D
var current_building: Hotspot.Type = Hotspot.Type.EMPTY
var upgrade_spot: Callable = build_settlement


func _ready() -> void:
	super()
	#Events.add_building_entered.connect(_on_add_building_entered)
	#Events.add_building_exited.connect(_on_add_building_exited)
	
	settlement_model.set_surface_override_material(0, holo_mat)
	settlement_model.set_surface_override_material(1, holo_mat)


func get_starting_resources() -> void:
	for hex in adjacent_hexes:
		if hex.terrain_type != Terrain.Type.DESERT:
			player_owner.change_resource(int(hex.terrain_type), 1)


func build_settlement(player_id: int) -> void:
	current_building = Hotspot.Type.SETTLEMENT
	player_owner = PlayerManager.GET_PLAYER_BY_ID(player_id)
	player_owner.add_settlement()
	if MatchLogic.CURRENT_ROUND == 2:
		get_starting_resources()
	
	settlement_model.visible = true
	settlement_model.set_surface_override_material(0, null)
	settlement_model.set_surface_override_material(1, player_owner.player_mat)
	upgrade_spot = build_castle
	for building in adjacent_buildings:
		if is_instance_valid(building):
			building.queue_free()
	#TODO roads
	#TODO ports


func build_castle(_player_id: int) -> void:
	current_building = Hotspot.Type.CASTLE
	player_owner.add_castle()
	settlement_model.visible = false
	
	castle_model.visible = true
	castle_model.set_surface_override_material(0, castle_base_mat)
	castle_model.set_surface_override_material(1, player_owner.player_mat)


func resource_rolled(type_index: int) -> void:
	if player_owner == null:
		return
	if current_building == Hotspot.Type.SETTLEMENT:
		player_owner.change_resource(type_index, 1)
	elif current_building == Hotspot.Type.CASTLE:
		player_owner.change_resource(type_index, 2)


func make_reachable() -> void:
	if player_owner == null:
		add_to_group("Empty")


func hotspot_clicked(player_id: int) -> void:
	build.rpc(player_id)


@rpc("any_peer", "call_local")
func build(player_id: int) -> void:
	upgrade_spot.call(player_id)
	Events.add_building_exited.emit()


func _on_add_building_entered(building_type: Hotspot.Type) -> void:
	if current_building == building_type:
		available_indicator.visible = true
		collision_layer = 1


func _on_add_building_exited() -> void:
	available_indicator.visible = false
	collision_layer = 0


func _on_selectable_hovered(hovered_object: Hotspot) -> void:
	if player_owner != null:
		return
	if hovered_object == self:
		settlement_model.visible = true
	else:
		settlement_model.visible = false
