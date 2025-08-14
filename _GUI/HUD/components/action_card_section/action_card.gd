extends Panel

const _FONT_SIZES: Dictionary[Global.ActionCardType, int] = {
	Global.ActionCardType.KNIGHT : 12,
	Global.ActionCardType.VICTORY_POINT : 12,
	Global.ActionCardType.YEAR_OF_PLENTY : 10,
	Global.ActionCardType.MONOPOLY : 8,
	Global.ActionCardType.FREE_ROADS : 12,
}
const _CARD_NAMES: Dictionary[Global.ActionCardType, String] = {
	Global.ActionCardType.KNIGHT : "Knight",
	Global.ActionCardType.VICTORY_POINT : "Victory Point",
	Global.ActionCardType.YEAR_OF_PLENTY : "Year of Plenty",
	Global.ActionCardType.MONOPOLY : "Monopoly",
	Global.ActionCardType.FREE_ROADS : "Free Roads",
}

@export var in_hand: bool = true
@export var title_label: Label
@export var amount_label: Label
@export var card_type: Global.ActionCardType

var empty_alpha: float = 0.10
var num_cards: int = 0


func _ready() -> void:
	modulate = Global._ACTION_CARD_COLORS[card_type]
	modulate.a = empty_alpha
	title_label.label_settings.font_size = _FONT_SIZES[card_type]
	title_label.text = _CARD_NAMES[card_type]
	
	Events.PLAYER_START.action_cards_changed.connect(_action_cards_changed)


func _action_cards_changed(cards_in_hand: Array[Global.ActionCardType], cards_used: Array[Global.ActionCardType]) -> void:
	num_cards = 0
	if in_hand:
		for i in cards_in_hand:
			if i == card_type:
				num_cards += 1
	else:
		for i in cards_used:
			if i == card_type:
				num_cards += 1
	
	modulate.a = 1.0
	if num_cards == 0:
		modulate.a = empty_alpha
	
	amount_label.text = str(num_cards)


func _on_gui_input(event: InputEvent) -> void:
	if num_cards == 0:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			print("Clicked")
			Events.HUD_START.action_card_clicked.emit(card_type)
