class_name HexRegion
extends Node3D

static var HEXES: Array[HexRegion] = []

const _PATH: String = "uid://coa2enk271cgj"
const _SIZE: float = 10.0 #8.66 is the model size

@export var roll_sprite: Sprite3D

var type_res: TerrainType
var hex_coord: Vector2i = Vector2i(0, 0)
var terrain: Terrain
var cam_pivot: CamPivot
var roll: int = 0

static func CREATE(new_coord: Vector2i = Vector2i(0, 0)) -> HexRegion:
	var new_region: HexRegion = load(_PATH).instantiate()
	new_region.hex_coord = new_coord
	return new_region

func _init() -> void:
	HEXES.append(self)

func _ready() -> void:
	global_position = get_world_coord(hex_coord)
	var idx: int = HEXES.find(self)
	var type: int = Global.HEX_TYPES[idx]
	type_res = load(Global.TYPE_RES[type])
	if type_res.terrain_scene:
		terrain = type_res.terrain_scene.instantiate()
		add_child(terrain)
	if type == 5:
		roll = 7
	else:
		roll = Global.HEX_ROLLS.pop_at(0)
		roll_sprite.texture = load(Global.ROLL_SPRITES[roll])
	cam_pivot = CamPivot.GET_PIVOT()

func get_world_coord(grid_coord: Vector2i) -> Vector3:
	var x_pos: float = ((pow(3, 0.5) / 2.0) * _SIZE) * grid_coord.x
	var z_pos: float = ((3.0 / 2.0) * _SIZE) * grid_coord.y
	return Vector3(x_pos, 0.0, z_pos)
