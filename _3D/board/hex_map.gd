class_name HexMap
extends Node3D

const _PATHS: Dictionary[int, String] = {
	0 : "uid://ckg14hym327hj",
}

@export var region_manager: Node3D


static func CREATE(index: int = 0) -> HexMap:
	var new_map: HexMap = load(_PATHS[index]).instantiate()
	return new_map


func _ready() -> void:
	add_hex_regions()
	
	await get_tree().create_timer(2.0).timeout
	get_tree().call_group("Building", "get_neighbors")


func add_hex_regions() -> void:
	#Row 1, 3 hexes
	for i in range(-1, 2):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i(i * 2, 2))
		region_manager.add_child(new_hex)
	#Row 2, 4 hexes
	for i in range(-2, 2):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i((i * 2) + 1, 1))
		region_manager.add_child(new_hex)
	#Row 3, 5 hexes
	for i in range(-2, 3):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i(i * 2, 0))
		region_manager.add_child(new_hex)
	#Row 4, 4 hexes
	for i in range(-2, 2):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i((i * 2) + 1, -1))
		region_manager.add_child(new_hex)
	#Row 5, 3 hexes
	for i in range(-1, 2):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i(i * 2, -2))
		region_manager.add_child(new_hex)
