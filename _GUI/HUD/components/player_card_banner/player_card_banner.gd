extends HUDComponent

const CARD_PATH: String = "uid://ds5xamo25scxy"

@export var row_parent: HBoxContainer


func _ready() -> void:
	pass


func _add_cards(players: Array[Player]) -> void:
	for player in players:
		var new_card: PlayerCard = load(CARD_PATH).instantiate()
		new_card.publisher = player.publisher
		add_child(new_card)
	for card in row_parent.get_children():
		row_parent.move_child(card, card.publisher.turn_index)
