class_name Hotspot
extends Area3D

enum Type{EMPTY, SETTLEMENT, CASTLE, HEX, ROAD}


func _ready() -> void:
	Events.BOARD_END.check_if_hovered.connect(_check_if_hovered)
	Events.BOARD_END


func hotspot_clicked(_player_id: int) -> void:
	pass


func _check_if_hovered(_hovered_object: Hotspot) -> void:
	pass
