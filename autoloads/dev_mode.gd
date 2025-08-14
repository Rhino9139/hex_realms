extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_M:
			Player.LOCAL_PLAYER.change_resources(
				{
				Global.Resources.BRICK : 1,
				Global.Resources.ORE : 1,
				Global.Resources.SHEEP : 1,
				Global.Resources.WHEAT : 1,
				Global.Resources.WOOD : 1,
				}
			)
		if event.pressed and event.keycode == KEY_N:
			Player.LOCAL_PLAYER.change_resources(
				{
				Global.Resources.BRICK : 1,
				Global.Resources.ORE : 1,
				Global.Resources.SHEEP : 1,
				Global.Resources.WHEAT : 1,
				Global.Resources.WOOD : 1,
				},
				false
			)
