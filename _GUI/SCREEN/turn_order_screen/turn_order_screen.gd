extends Screen

@export var center_pivot: Control

var rows: Array[RollRow] = []
var num_players: int = 4
var num_done: int = 0
var x_pos: float = 0


func _ready() -> void:
	var players: Array[Player] = PlayerManager.GET_PLAYERS()
	num_players = players.size()
	for i in num_players:
		var new_row: RollRow = RollRow.CREATE(players[i])
		center_pivot.add_child(new_row)
		new_row.position.y = i * 75
		new_row.position.x = x_pos
		new_row.roll_finished.connect(_on_roll_finished)
		new_row.name = str("Player ", i)
		rows.append(new_row)


func reorder_rows() -> void:
	for i in rows.size():
		rows[i].move_row(i * 75)
		rows[i].player.turn_index = i + 1


func sort_decending(a, b) -> bool:
	if a.roll_final > b.roll_final:
		return true
	return false


func _on_roll_finished() -> void:
	rows.sort_custom(sort_decending)
	num_done += 1
	if num_done == num_players:
		await get_tree().create_timer(0.50).timeout
		reorder_rows()
		await get_tree().create_timer(1.0).timeout
		Events.SCREEN_START.turn_order_created.emit()
