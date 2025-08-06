class_name HexRegion
extends Area3D

static var ROBBER_HEX: HexRegion

const _PATH: String = "uid://coa2enk271cgj"
const _SIZE: float = 10.0 #8.66 is the model size

@export var is_desert: bool = false
@export var roll_sprite: Sprite3D
@export var hover_indicator: MeshInstance3D

var type_res: TerrainType
var hex_coord: Vector2i = Vector2i(0, 0)
var terrain_model: Terrain
var roll: int = 0
var building_array: Array[BuildingHotspot] = []
var neighbor_players: Array[Player] = []


static func CREATE(new_coord: Vector2i = Vector2i(0, 0)) -> HexRegion:
	var new_region: HexRegion = load(_PATH).instantiate()
	new_region.hex_coord = new_coord
	new_region.name = str("Hex", new_coord)
	return new_region


func _ready() -> void:
	var idx: int = int(name)
	
	if is_desert:
		var terrain: Node3D = Terrain._SCENES[Terrain.Type.DESERT].instantiate()
		add_child(terrain)
		terrain.global_position = global_position
		roll = 7
		#Robber Hex
	else:
		var type_idx: int = Terrain.TYPE_ARRAY[idx]
		var terrain: Node3D = Terrain._SCENES[type_idx].instantiate()
		add_child(terrain)
		terrain.global_position = global_position
		roll = Global.HEX_ROLLS[idx]
		roll_sprite.texture = load(Global.ROLL_SPRITES[roll])
	
	
	await get_tree().create_timer(1.0).timeout
	collision_layer = 0


func number_rolled(rolled_total: int) -> void:
	if type_res.index == 5 or ROBBER_HEX == self:
		return
	if roll == rolled_total:
		for i in building_array:
			if is_instance_valid(i):
				i.resource_rolled(type_res.index)


func make_available() -> void:
	if ROBBER_HEX != self:
		set_collision_layer_value(3, true)


func make_unavailable() -> void:
	collision_layer = 0
	hide_hover()


func show_hover() -> void:
	hover_indicator.visible = true


func hide_hover() -> void:
	hover_indicator.visible = false


func get_world_coord(grid_coord: Vector2i) -> Vector3:
	var x_pos: float = ((pow(3, 0.5) / 2.0) * _SIZE) * grid_coord.x
	var z_pos: float = ((3.0 / 2.0) * _SIZE) * grid_coord.y
	return Vector3(x_pos, 0.0, z_pos)


func add_build_spot(new_spot: BuildingHotspot) -> void:
	if building_array.has(new_spot):
		return
	building_array.append(new_spot)


func get_neighbor_players() -> Array[Player]:
	neighbor_players = []
	for i in building_array:
		if is_instance_valid(i):
			if i.player != null:
				if neighbor_players.has(i.player) == false:
					neighbor_players.append(i.player)
	return neighbor_players


@rpc("any_peer", "call_local")
func move_robber() -> void:
	ROBBER_HEX = self
	EventTower.move_robber_requested.emit(global_position)
