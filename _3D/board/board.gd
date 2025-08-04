class_name Board
extends Node3D


func _ready() -> void:
	EventTower.add_board_requested.connect(_on_add_board_requested)
	EventTower.destroy_board_requested.connect(_on_destroy_board_requested)
	EventTower.generate_board_requested.connect(_on_generate_board_requested)


func add_hex_regions() -> void:
	#Row 1, 3 hexes
	for i in range(-1, 2):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i(i * 2, 2))
		add_child(new_hex)
	#Row 2, 4 hexes
	for i in range(-2, 2):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i((i * 2) + 1, 1))
		add_child(new_hex)
	#Row 3, 5 hexes
	for i in range(-2, 3):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i(i * 2, 0))
		add_child(new_hex)
	#Row 4, 4 hexes
	for i in range(-2, 2):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i((i * 2) + 1, -1))
		add_child(new_hex)
	#Row 5, 3 hexes
	for i in range(-1, 2):
		var new_hex: HexRegion = HexRegion.CREATE(Vector2i(i * 2, -2))
		add_child(new_hex)


func _on_add_board_requested() -> void:
	EventTower.add_player_camera_requested.emit()
	
	add_hex_regions()
	await get_tree().create_timer(2.0).timeout
	get_tree().call_group("Building", "get_neighbors")


func _on_destroy_board_requested() -> void:
	EventTower.destroy_player_camera_requested.emit()
	
	for child in get_children():
		child.queue_free()


func _on_generate_board_requested() -> void:
	Global.HEX_TYPES.shuffle()
	Global.HEX_ROLLS.shuffle()
	Global.PORT_TYPES.shuffle()
	Global.ACTION_CARDS.shuffle()
	
	var hex_types: Array = Global.HEX_TYPES
	var hex_rolls: Array = Global.HEX_ROLLS
	var port_types: Array = Global.PORT_TYPES
	
	share_board.rpc(hex_types, hex_rolls, port_types)


@rpc("authority", "call_local")
func share_board(new_types: Array, new_rolls: Array, new_ports: Array) -> void:
	Global.HEX_TYPES = new_types
	Global.HEX_ROLLS = new_rolls
	Global.PORT_TYPES = new_ports
	
	EventTower.board_generated.emit()
	EventTower.add_board_requested.emit()
