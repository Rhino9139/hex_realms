extends HUDComponent

const CARD_PATH: String = "uid://ds5xamo25scxy"

@export var row_parent: HBoxContainer


func _ready() -> void:
	Events.HUD_END.add_player_cards.connect(_add_player_cards)


func _add_player_cards(players: Array[Player]) -> void:
	for player in players:
		var new_card: PlayerCard = load(CARD_PATH).instantiate()
		new_card.publisher = player.publisher
		new_card.player_name = player.player_name
		row_parent.add_child(new_card)
	for card in row_parent.get_children():
		row_parent.move_child(card, card.publisher.turn_index)
