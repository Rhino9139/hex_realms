class_name HexHotspot
extends Hotspot

@export var is_desert: bool = false
@export var roll_sprite: Sprite3D
@export var hover_indicator: MeshInstance3D

var terrain_type: Terrain.Type
var terrain_model: Terrain
var roll: int = 0
var building_array: Array[BuildingHotspot] = []
var neighbor_players: Array[Player] = []
var has_robber: bool = false


func inner_ready() -> void:
	hotspot_type = Hotspot.Type.HEX
	var idx: int = int(name)
	if is_desert:
		terrain_type = Terrain.Type.DESERT
		var terrain: Node3D = Terrain._SCENES[terrain_type].instantiate()
		add_child(terrain)
		terrain.global_position = global_position
		roll = 7
		has_robber = true
		Events.BOARD_START.desert_spawned.emit(self)
	else:
		terrain_type = Terrain.TYPE_ARRAY[idx]
		var terrain: Node3D = Terrain._SCENES[terrain_type].instantiate()
		add_child(terrain)
		terrain.global_position = global_position
		roll = Global.HEX_ROLLS[idx]
		roll_sprite.texture = load(Global.ROLL_SPRITES[roll])
	Events.BOARD_END.clear_robber.connect(_clear_robber)


func has_availability(_message: Message) -> bool:
	if has_robber:
		return false
	return true


func activate_hotspot(_message: Message) -> void:
	get_tree().call_group("Hex", "_clear_robber")
	Events.BOARD_START.robber_hex_chosen.emit(self)
	has_robber = true


func _clear_robber() -> void:
	has_robber = false
