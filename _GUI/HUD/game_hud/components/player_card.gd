class_name PlayerCard
extends PanelContainer

const _PATH: String = "uid://ds5xamo25scxy"

@export var name_label: Label
@export var turn_arrow: TextureRect
@export var point_label: Label
@export var card_count_label: Label
@export var knight_count_label: Label
@export var longest_road: TextureRect
@export var largest_army: TextureRect

var player: Player


static func CREATE(new_player: Player) -> PlayerCard:
	var new_player_card: PlayerCard = load(_PATH).instantiate()
	new_player_card.player = new_player
	return new_player_card


func _ready() -> void:
	name_label.text = player.player_name
	self_modulate = Global.PLAYER_MATS[player.player_index].albedo_color


func _process(_delta: float) -> void:
	card_count_label.text = str(player.num_cards)
	knight_count_label.text = str(player.knight_count)
	point_label.text = str(player.total_points)
	if player.has_longest_road:
		longest_road.visible = true
	else:
		longest_road.visible = false
	if player.has_largest_army:
		largest_army.visible = true
	else:
		largest_army.visible = false


func check_turn() -> void:
	turn_arrow.visible = false
	if MatchManager.current_turn == player.turn_index:
		turn_arrow.visible = true
