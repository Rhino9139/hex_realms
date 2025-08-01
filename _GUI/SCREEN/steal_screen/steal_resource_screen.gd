extends Screen

signal resource_stolen(player: Player)

@export var p1_button: Button
@export var p2_button: Button
@export var p3_button: Button

var players: Array[Player]
var buttons: Array[Button]

func _ready() -> void:
	buttons = [p1_button, p2_button, p3_button]
	for i in players.size():
		buttons[i].text = players[i].player_name
		buttons[i].visible = true
		buttons[i].pressed.connect(_on_pressed.bind(players[i]))

func _on_pressed(player: Player) -> void:
	resource_stolen.emit(player)
	queue_free()
