class_name PlayerCard
extends PanelContainer

@export var name_label: Label
@export var point_label: Label
@export var card_count_label: Label
@export var knight_count_label: Label
@export var longest_road: TextureRect
@export var largest_army: TextureRect

var player: Player


func _ready() -> void:
	name_label.text = player.player_name
	self_modulate = player.player_color
	player.knights_changed.connect(_knights_changed)
	player.points_changed.connect(_points_changed)
	player.resource_cards_changed.connect(_resource_cards_changed)
	player.largest_army_updated.connect(_largest_army_changed)
	player.longest_road_updated.connect(_longest_road_changed)


func _knights_changed() -> void:
	knight_count_label.text = str(player.knight_count)


func _points_changed() -> void:
	point_label.text = str(player.total_points)


func _resource_cards_changed() -> void:
	card_count_label.text = str(player.num_cards)


func _largest_army_changed() -> void:
	largest_army.visible = player.has_largest_army


func _longest_road_changed() -> void:
	longest_road.visible = player.has_longest_road
