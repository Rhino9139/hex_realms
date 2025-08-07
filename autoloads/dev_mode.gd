extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_M:
			Player.LOCAL_PLAYER.change_resources([1, 1, 1, 1, 1])
		if event.pressed and event.keycode == KEY_N:
			Player.LOCAL_PLAYER.change_resources([1, 1, 1, 1, 1], false)
