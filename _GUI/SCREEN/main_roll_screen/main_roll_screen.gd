extends Screen

@export var die_1: Label
@export var die_2: Label
@export var dice_row: HBoxContainer
@export var roll_flash: TextureRect

var die_array_1: Array[int] = []
var die_array_2: Array[int] = []
var roll_amount: int = 10
var screen_size: Vector2
var roll_wait: float = 0.10


func _ready() -> void:
	_roll_dice(message.die_1, message.die_2)


func _roll_dice(new_die_1: int, new_die_2: int) -> void:
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
	tween.tween_property(roll_flash, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.50)
	tween.tween_property(roll_flash, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.50)
	await tween.finished
	Events.SCREEN_START.dice_rolled.emit(total)
	queue_free()
