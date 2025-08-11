class_name PlayerCard
extends PanelContainer

@export var name_label: Label
@export var point_label: Label
@export var card_count_label: Label
@export var knight_count_label: Label
@export var longest_road: TextureRect
@export var largest_army: TextureRect

var publisher: Player.Publisher
var player_name: String

func _ready() -> void:
	name_label.text = player_name
	self_modulate = publisher.player_color
	publisher.knights_changed.connect(_knights_changed)
	publisher.points_changed.connect(_points_changed)
	publisher.resource_cards_changed.connect(_resource_cards_changed)
	publisher.largest_army_updated.connect(_largest_army_changed)
	publisher.longest_road_updated.connect(_longest_road_changed)


func _knights_changed(new_count: int) -> void:
	knight_count_label.text = str(new_count)


func _points_changed(new_points: int) -> void:
	point_label.text = str(new_points)


func _resource_cards_changed(new_count: int) -> void:
	card_count_label.text = str(new_count)


func _largest_army_changed(has_largest: bool) -> void:
	largest_army.visible = has_largest


func _longest_road_changed(has_longest: bool) -> void:
	longest_road.visible = has_longest
