class_name HexMap
extends Node3D

@export var region_manager: Node3D

func _ready() -> void:
	add_hex_regions()

func add_hex_regions() -> void:
	#Row 1, 3 hexes
	for i in range(-1, 2):
		var new_hex: HexRegion = HexRegion.create(Vector2i(i * 2, 2))
		region_manager.add_child(new_hex)
	#Row 2, 4 hexes
	for i in range(-2, 2):
		var new_hex: HexRegion = HexRegion.create(Vector2i((i * 2) + 1, 1))
		add_child(new_hex)
	#Row 3, 5 hexes
	for i in range(-2, 3):
		var new_hex: HexRegion = HexRegion.create(Vector2i(i * 2, 0))
		add_child(new_hex)
	#Row 4, 4 hexes
	for i in range(-2, 2):
		var new_hex: HexRegion = HexRegion.create(Vector2i((i * 2) + 1, -1))
		add_child(new_hex)
	#Row 5, 3 hexes
	for i in range(-1, 2):
		var new_hex: HexRegion = HexRegion.create(Vector2i(i * 2, -2))
		add_child(new_hex)
