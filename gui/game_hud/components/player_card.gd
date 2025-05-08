class_name PlayerCard
extends HBoxContainer

const _PATH: String = "uid://ds5xamo25scxy"

@export var name_label: Label

var player: Player

static func CREATE(new_player: Player) -> PlayerCard:
	var new_player_card: PlayerCard = load(_PATH).instantiate()
	new_player_card.player = new_player
	return new_player_card

func _ready() -> void:
	name_label.text = player.player_name
	modulate = Global.PLAYER_MATS[player.get_index()].albedo_color
