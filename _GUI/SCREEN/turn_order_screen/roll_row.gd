class_name RollRow
extends HBoxContainer

signal roll_finished

const _PATH: String = "uid://cx0ndasoeyppx"

@export var name_label: Label
@export var roll_label: Label
@export var roll_button: Button
@export var button_pivot: Control

var player: Player
var roll_array: Array[int] = []
var roll_final: int = 0

static func CREATE(new_player: Player) -> RollRow:
	var new_row: RollRow = load(_PATH).instantiate()
	new_row.player = new_player
	return new_row

func _ready() -> void:
	name_label.text = player.player_name
	name_label.modulate = player.player_color
	roll_array = []
	for i in 15:
		roll_array.append(randi_range(0, 100))
	if player.player_id == multiplayer.get_unique_id():
		button_pivot.visible = true
		roll_label.visible = false

func move_row(new_y: float) -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "position", Vector2(position.x, new_y), 0.75)

func _on_roll_pressed() -> void:
	roll_label.visible = true
	share_roll_pressed.rpc(roll_array)

@rpc("any_peer", "call_local") 
func share_roll_pressed(new_roll_array: Array[int]) -> void:
	roll_array = new_roll_array
	roll_button.disabled = true
	button_pivot.visible = false
	var cycle_time: float = 0.05
	for i in roll_array.size():
		roll_label.text = str(roll_array[i])
		await get_tree().create_timer(cycle_time).timeout
		cycle_time += 0.005 * i
	roll_label.add_theme_font_size_override("font_size", 45)
	roll_label.modulate = Color.SEA_GREEN
	roll_final = roll_array.back()
	roll_finished.emit()
