class_name HexRegion
extends Node3D

static var HEXES: Array[HexRegion] = []

const scene_path: String = "uid://coa2enk271cgj"
const SIZE: float = 10.0 #8.66 is the model size

@export var main_hex: MeshInstance3D

var type_res: TerrainType
var hex_coord: Vector2i = Vector2i(0, 0)

static func create(new_coord: Vector2i = Vector2i(0, 0)) -> HexRegion:
	var new_region: HexRegion = load(scene_path).instantiate()
	new_region.hex_coord = new_coord
	return new_region

static func get_world_coord(grid_coord: Vector2i) -> Vector3:
	var x_pos: float = ((pow(3, 0.5) / 2.0) * SIZE) * grid_coord.x
	var z_pos: float = ((3.0 / 2.0) * SIZE) * grid_coord.y
	return Vector3(x_pos, 0.0, z_pos)

func _init() -> void:
	HEXES.append(self)

func _ready() -> void:
	global_position = get_world_coord(hex_coord)
	var idx: int = HEXES.find(self)
	var type: int = Global.HEX_TYPES[idx]
	type_res = load(Global.TYPE_RES[type])
	main_hex.set_surface_override_material(0, type_res.material)
