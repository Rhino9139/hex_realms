extends State

@export var roll_screen: Control
@export var roll_color: Color
@export var turn_color: Color

func enter() -> void:
	roll_screen.roll_finished.connect(_on_roll_finished)
	base.turn_progress_bar.tint_progress = roll_color
	base.enable_roll()

func exit() -> void:
	roll_screen.roll_finished.disconnect(_on_roll_finished)
	base.turn_progress_bar.tint_progress = turn_color

func _on_roll_button_pressed() -> void:
	base.disable_roll()
	base.disable_timer()
	roll_screen.roll_dice()

func _on_roll_finished(roll_total: int) -> void:
	if roll_total == 7:
		state_changed.emit("RobberMoveState")
	else:
		state_changed.emit("ActiveState")
