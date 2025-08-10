extends Node

#func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.pressed and event.keycode == KEY_M:
			#Events.UI_END.toggle_buy_button_off.emit()
			#Player.LOCAL_PLAYER.change_resources([1, 1, 1, 1, 1])
		#if event.pressed and event.keycode == KEY_N:
			#Player.LOCAL_PLAYER.change_resources([1, 1, 1, 1, 1], false)
