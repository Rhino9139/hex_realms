class_name RoadHotspot
extends Area3D

static var current_index: int = 0
static var num_hotspots: int = 0
static var LONGEST: int = 0

@export var road_model: MeshInstance3D
@export var indicator_model: MeshInstance3D
@export var neighbor_area: Area3D
@export var TEST_MAT: StandardMaterial3D

var idx: int = -1
var neighbors: Array[RoadHotspot] = []
var neighbors_clean: Array[RoadHotspot] = []
var ally_neighbors: Array[RoadHotspot] = []
var tail_segements: Array[RoadHotspot] = []
var tail_id: Array[int] = [0, 1, 2, 3]
var player: Player

#Longest Road Logic
var marked: bool = false
var tail_size: int = 0
var road_tails: Array[int] = []


func _init() -> void:
	idx = current_index
	current_index += 1


func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	neighbor_area.queue_free()
	collision_layer = 0
	collision_mask = 0
	for i in neighbors.size():
		if is_instance_valid(neighbors[i]):
			neighbors_clean.append(neighbors[i])


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


func begin_length_search() -> void:
	var roads: Array[Node] = get_tree().get_nodes_in_group("MyRoads")
	for i in roads:
		if i.ally_neighbors.size() <= 2:
			i.chain_length(0, null)
		get_tree().call_group("MyRoads", "reset_longest")
	print("Current Longest: ", LONGEST)


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
	print(tail_size)


func reset_longest() -> void:
	tail_segements = []
	marked = false
	tail_size = 0


func reset_ally_neighbors() -> void:
	ally_neighbors = []
	for i in neighbors_clean:
		if i.is_in_group("MyRoads"):
			ally_neighbors.append(i)


func _on_area_entered(area: Area3D) -> void:
	if area is RoadHotspot:
		if area.idx < idx:
			area.queue_free()
		else:
			queue_free()


func _on_neighbor_area_entered(area: Area3D) -> void:
	if area == self:
		return
	if neighbors.has(area as RoadHotspot) == false:
		neighbors.append(area as RoadHotspot)


@rpc("any_peer", "call_local")
func build(player_id: int) -> void:
	player = PlayerManager.GET_PLAYER_BY_ID(player_id)
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
		get_tree().call_group("MyRoads", "reset_longest")
		get_tree().call_group("MyRoads", "reset_ally_neighbors")
		for i in neighbors_clean:
			i.make_reachable()
		begin_length_search()
