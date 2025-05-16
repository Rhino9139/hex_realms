extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_M:
			for i in 5:
				Player.LOCAL_PLAYER.change_resource(i, 1)
		if event.pressed and event.keycode == KEY_K:
			for i in 5:
				Player.LOCAL_PLAYER.change_resource(i, -1)
