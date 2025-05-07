extends State

@export var roll_screen: Control
@export var roll_color: Color
@export var turn_color: Color

func enter() -> void:
	if roll_screen.roll_finished.is_connected(_on_roll_finished) == false:
		roll_screen.roll_finished.connect(_on_roll_finished)
	base.turn_progress_bar.tint_progress = roll_color
	base.enable_roll()
	base.activate_timer_bar(GameSettings.ROLL_WAIT_TIME, "Roll")

func exit() -> void:
	base.turn_progress_bar.tint_progress = turn_color
	base.activate_timer_bar(GameSettings.TURN_TIME, "Turn")

func _on_roll_button_pressed() -> void:
	base.disable_roll()
	base.disable_timer()
	roll_screen.roll_dice()

func _on_roll_finished(_total: int) -> void:
	state_changed.emit("ActiveState")
