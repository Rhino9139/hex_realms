class_name PlayerCard
extends VBoxContainer

const _PATH: String = "uid://ds5xamo25scxy"

@export var name_label: Label
@export var turn_arrow: TextureRect
@export var point_label: Label
@export var card_count_label: Label
@export var knight_count_label: Label

var player: Player

static func CREATE(new_player: Player) -> PlayerCard:
	var new_player_card: PlayerCard = load(_PATH).instantiate()
	new_player_card.player = new_player
	return new_player_card

func _ready() -> void:
	name_label.text = player.player_name
	modulate = Global.PLAYER_MATS[player.get_index()].albedo_color

func _process(_delta: float) -> void:
	card_count_label.text = str(player.num_cards)
	knight_count_label.text = str(player.knight_used)
	point_label.text = str(player.total_points)

func check_turn() -> void:
	turn_arrow.visible = false
	if GameHUD.MASTER.current_turn_index == player.turn_index:
		turn_arrow.visible = true
