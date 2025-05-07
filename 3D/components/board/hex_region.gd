class_name HexRegion
extends Node3D

static var HEXES: Array[HexRegion] = []

const _PATH: String = "uid://coa2enk271cgj"
const _SIZE: float = 10.0 #8.66 is the model size

@export var roll_sprite: Sprite3D
@export_group("Building Spots")
@export var building_1: BuildingHotspot
@export var building_2: BuildingHotspot
@export var building_3: BuildingHotspot
@export var building_4: BuildingHotspot
@export var building_5: BuildingHotspot
@export var building_6: BuildingHotspot

var type_res: TerrainType
var hex_coord: Vector2i = Vector2i(0, 0)
var terrain_model: Terrain
var roll: int = 0
var building_array: Array[BuildingHotspot]

static func CREATE(new_coord: Vector2i = Vector2i(0, 0)) -> HexRegion:
	var new_region: HexRegion = load(_PATH).instantiate()
	new_region.hex_coord = new_coord
	return new_region

func _init() -> void:
	HEXES.append(self)

func _ready() -> void:
	building_array = [building_1, building_2, building_3, building_4, building_5, building_6]
	global_position = get_world_coord(hex_coord)
	var idx: int = HEXES.find(self)
	var type: int = Global.HEX_TYPES[idx]
	type_res = Global.TYPE_RES[type]
	if type_res.terrain_scene:
		terrain_model = type_res.terrain_scene.instantiate()
		add_child(terrain_model)
	if type == 5:
		roll = 7
		Robber.CREATE(global_position)
	else:
		roll = Global.HEX_ROLLS.pop_at(0)
		roll_sprite.texture = load(Global.ROLL_SPRITES[roll])

func number_rolled(_rolled_total: int) -> void:
	if type_res.index == 5:
		return
	for i in building_array:
		if is_instance_valid(i):
			i.resource_rolled(type_res.index)

func get_world_coord(grid_coord: Vector2i) -> Vector3:
	var x_pos: float = ((pow(3, 0.5) / 2.0) * _SIZE) * grid_coord.x
	var z_pos: float = ((3.0 / 2.0) * _SIZE) * grid_coord.y
	return Vector3(x_pos, 0.0, z_pos)
