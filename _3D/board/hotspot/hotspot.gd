class_name Hotspot
extends Area3D

enum Type{EMPTY, SETTLEMENT, CASTLE, HEX, ROAD}


func _ready() -> void:
	Events.selectable_hovered.connect(_on_selectable_hovered)


func hotspot_clicked(_player_id: int) -> void:
	pass


func _on_selectable_hovered(_hovered_object: Hotspot) -> void:
	pass
