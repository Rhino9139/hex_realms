extends Control

signal roll_finished(roll_total: int)

@export var die_1: Label
@export var die_2: Label
@export var dice_row: HBoxContainer
@export var roll_flash: TextureRect

var die_array_1: Array[int] = []
var die_array_2: Array[int] = []
var roll_amount: int = 10
var screen_size: Vector2

func make_rand_arrays() -> void:
	die_array_1 = []
	die_array_2 = []
	for i in roll_amount:
		die_array_1.append(randi_range(1, 6))
		die_array_2.append(randi_range(1, 6))

func roll_dice() -> void:
	make_rand_arrays()
	share_roll.rpc(die_array_1, die_array_2)

@rpc("any_peer", "call_local")
func share_roll(new_die_1_rolls: Array[int], new_die_2_rolls: Array[int]) -> void:
	screen_size = get_viewport_rect().size
	dice_row.scale = Vector2(1.0, 1.0)
	dice_row.position = screen_size / 2.0
	dice_row.position.x -= (dice_row.size.x / 2.0)
	dice_row.position.y -= (dice_row.size.y / 2.0)
	visible = true
	for i in roll_amount:
		die_1.text = str(new_die_1_rolls[i])
		die_2.text = str(new_die_2_rolls[i])
		await get_tree().create_timer(0.15).timeout
	var total: int = new_die_1_rolls.back() + new_die_2_rolls.back()
	var tween: Tween = create_tween()
	tween.tween_interval(0.25)
	tween.tween_property(roll_flash, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.75)
	tween.tween_property(roll_flash, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.75)
	tween.tween_property(dice_row, "scale", Vector2.ONE * 0.5, 0.5)
	tween.parallel().tween_property(dice_row, "position", Vector2(754.0, 576.0), 0.5)
	await tween.finished
	get_tree().call_group("RobberAbsent", "number_rolled", total)
	roll_finished.emit(total)
