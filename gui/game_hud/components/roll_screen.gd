extends Control

signal roll_finished(roll_total: int)

@export var die_1: Label
@export var die_2: Label
@export var dice_row: HBoxContainer
@export var roll_flash: TextureRect

var die_array_1: Array[int] = []
var die_array_2: Array[int] = []
var die_1_final: int = 0
var die_2_final: int = 0
var roll_amount: int = 10
var screen_size: Vector2
var roll_wait: float = 0.1

func make_rand_arrays() -> void:
	die_1_final = randi_range(1, 6)
	die_2_final = randi_range(1, 6)

func roll_dice(_roll: int = 0) -> void:
	make_rand_arrays()
	share_roll.rpc(die_1_final, die_2_final)

@rpc("any_peer", "call_local")
func share_roll(new_die_1: int, new_die_2: int) -> void:
	screen_size = get_viewport_rect().size
	dice_row.scale = Vector2(1.0, 1.0)
	dice_row.position = screen_size / 2.0
	dice_row.position.x -= (dice_row.size.x / 2.0)
	dice_row.position.y -= (dice_row.size.y / 2.0)
	visible = true
	die_2.visible = true
	roll_wait = 0.1
	for i in roll_amount:
		die_1.text = str(randi_range(1, 6))
		die_2.text = str(randi_range(1, 6))
		await get_tree().create_timer(roll_wait).timeout
		roll_wait += 0.02
	die_1.text = str(new_die_1)
	die_2.text = str(new_die_2)
	var total: int = new_die_1 + new_die_2
	var tween: Tween = create_tween()
	tween.tween_interval(0.35)
	tween.tween_property(die_2, "visible", false, 0.0)
	tween.tween_property(die_1, "text", str(total), 0.0)
	tween.tween_property(roll_flash, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.75)
	tween.tween_property(roll_flash, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.75)
	tween.tween_property(dice_row, "scale", Vector2.ONE * 0.5, 0.5)
	tween.parallel().tween_property(dice_row, "position", Vector2(400.0, 576.0), 0.5)
	await tween.finished
	get_tree().call_group("RobberAbsent", "number_rolled", total)
	roll_finished.emit(total)
