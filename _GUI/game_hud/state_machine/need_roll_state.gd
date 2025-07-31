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

#func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.pressed and event.keycode == KEY_N:
			#print("CHEAT")
			#_on_roll_button_pressed(7)

func _on_roll_button_pressed(roll: int = 0) -> void:
	base.disable_roll()
	base.disable_timer()
	roll_screen.roll_dice(roll)

func _on_roll_finished(roll_total: int) -> void:
	if roll_total == 7:
		swap_to_cut.rpc()
	else:
		state_changed.emit("ActiveState")

@rpc("any_peer", "call_local")
func swap_to_cut() -> void:
	state_changed.emit("CutResourcesState")
