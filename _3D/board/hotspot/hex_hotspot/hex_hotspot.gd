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
	else:
		terrain_type = Terrain.TYPE_ARRAY[idx]
		var terrain: Node3D = Terrain._SCENES[terrain_type].instantiate()
		add_child(terrain)
		terrain.global_position = global_position
		roll = Global.HEX_ROLLS[idx]
		roll_sprite.texture = load(Global.ROLL_SPRITES[roll])


func number_rolled(rolled_total: int) -> void:
	if terrain_type == Terrain.Type.DESERT:
		return
	if roll == rolled_total:
		pass


func make_available() -> void:
	if has_robber == false:
		set_collision_layer_value(3, true)


func make_unavailable() -> void:
	collision_layer = 0
	hover_indicator.visible = false


func _on_selectable_hovered(hovered_object: Node3D) -> void:
	if hovered_object == self:
		hover_indicator.visible = true
	else:
		hover_indicator.visible = false


@rpc("any_peer", "call_local")
func move_robber() -> void:
	has_robber = true
	Events.robber_moved.emit(global_position)
