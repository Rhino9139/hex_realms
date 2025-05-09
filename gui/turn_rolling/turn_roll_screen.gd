extends Control

@export var center_pivot: Control

var rows: Array[RollRow] = []
var num_players: int = 4
var num_done: int = 0

func _ready() -> void:
	for i in 4:
		var new_row: RollRow = RollRow.CREATE(Player.new())
		center_pivot.add_child(new_row)
		new_row.position.y = i * 75
		new_row.roll_finished.connect(_on_roll_finished)
		new_row.name_label.text = str("Player ", i)
		new_row.name = str("Player ", i)
		rows.append(new_row)

func reorder_rows() -> void:
	for i in rows.size():
		rows[i].move_row(i * 75)

func sort_decending(a, b) -> bool:
	if a.roll_final > b.roll_final:
		return true
	return false

func _on_roll_finished() -> void:
	rows.sort_custom(sort_decending)
	num_done += 1
	if num_done == num_players:
		reorder_rows()
