class_name Hotspot
extends Area3D

enum Type{EMPTY, SETTLEMENT, CASTLE, HEX, ROAD}

@export var available_indicator: MeshInstance3D
@export var main_model: MeshInstance3D
@export var hover_model: MeshInstance3D

var hotspot_type: Type


func _ready() -> void:
	Events.BOARD_END.show_hover.connect(_show_hover)
	Events.BOARD_END.make_hotspot_available.connect(_make_hotspot_available)
	Events.BOARD_END.make_hotspot_unavailable.connect(_make_hotspot_unavailable)
	Events.BOARD_END.click_hotspot.connect(_click_hotspot)
	inner_ready()


func inner_ready() -> void:
	pass


func _show_hover(message: Message) -> void:
	if hover_model == null:
		return
	if message.hovered_object == self:
		hover_model.visible = true
	else:
		hover_model.visible = false


func _make_hotspot_available(message: Message) -> void:
	if hotspot_type == message.hotspot_type:
		available_indicator.visible = true
		collision_layer = 1


func _make_hotspot_unavailable() -> void:
	if hover_model:
		hover_model.visible = false
	available_indicator.visible = false
	collision_layer = 0


func _click_hotspot(message: Message) -> void:
	if message.hovered_object == self:
		activate_hotspot(message)


func activate_hotspot(_message: Message) -> void:
	pass


class Message:
	var player: Player
	var hotspot_type: Hotspot.Type
	var hovered_object: Hotspot
	
	func _init(_player: Player, _h_type: Hotspot.Type, _h_object: Hotspot) -> void:
		player = _player
		hotspot_type = _h_type
		hovered_object = _h_object
