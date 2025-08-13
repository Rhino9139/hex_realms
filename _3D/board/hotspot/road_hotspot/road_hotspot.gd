class_name RoadHotspot
extends Hotspot

static var LONGEST: int = 0

@export var adjacent_roads: Array[RoadHotspot]
@export var adjacent_buildings: Array[BuildingHotspot]

var neighbors: Array[RoadHotspot] = []
var neighbors_clean: Array[RoadHotspot] = []
var ally_neighbors: Array[RoadHotspot] = []
var tail_segements: Array[RoadHotspot] = []
var tail_id: Array[int] = [0, 1, 2, 3]
var can_build: bool = false
var player_owner: Player

#Longest Road Logic
var marked: bool = false
var tail_size: int = 0
var road_tails: Array[int] = []


func inner_ready() -> void:
	hotspot_type = Hotspot.Type.ROAD


func get_availability() -> bool:
	var is_available: bool = false
	var local_id: int = multiplayer.get_unique_id()
	for road in adjacent_roads:
		if road.player_owner != null:
			if road.player_owner.player_id == local_id:
				is_available = true
	for building in adjacent_buildings:
		if is_instance_valid(building):
			if building.player_owner != null:
				if building.player_owner.player_id == local_id:
					is_available = true
	
	return is_available


func begin_length_search() -> void:
	var roads: Array[Node] = get_tree().get_nodes_in_group("MyRoads")
	for i in roads:
		if i.ally_neighbors.size() <= 2:
			i.chain_length(0, null)
		get_tree().call_group("MyRoads", "reset_longest")
	#print("Current Longest: ", LONGEST)


func chain_length(current_length: int, upstream_segment: RoadHotspot) -> void:
	tail_segements = []
	var branch_neighbors: Array[RoadHotspot] = []
	if upstream_segment != null:
		tail_segements = upstream_segment.tail_segements
		branch_neighbors = upstream_segment.ally_neighbors
	tail_segements.append(self)
	tail_size = current_length + 1
	for i in ally_neighbors:
		if tail_segements.has(i) == false and branch_neighbors.has(i) == false:
			i.chain_length(tail_size, self)
	if tail_size > LONGEST:
		LONGEST = tail_size
	#print(tail_size)


func reset_longest() -> void:
	tail_segements = []
	marked = false
	tail_size = 0


func reset_ally_neighbors() -> void:
	ally_neighbors = []
	for i in neighbors_clean:
		if i.is_in_group("MyRoads"):
			ally_neighbors.append(i)


func activate_hotspot(message: Message) -> void:
	build.rpc(message.player.player_id)
	Events.BOARD_START.building_added.emit(self)


@rpc("any_peer", "call_local")
func build(player_id: int) -> void:
	player_owner = PlayerManager.GET_PLAYER_BY_ID(player_id)
	player_owner.add_road()
	main_model.set_surface_override_material(0, player_owner.player_mat)
	main_model.visible = true
	if player_owner == player_owner.LOCAL_PLAYER:
		add_to_group("MyRoads")
		get_tree().call_group("MyRoads", "reset_longest")
		get_tree().call_group("MyRoads", "reset_ally_neighbors")
		begin_length_search()
