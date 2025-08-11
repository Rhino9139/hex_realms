extends State

func enter() -> void:
	Events.add_building_exited.connect(_on_add_building_exited)
	Events.add_road_exited.connect(_on_add_road_exited)
	
	Events.add_building_entered.emit(Hotspot.Type.EMPTY)
	Events.player_activated.emit()


func exit() -> void:
	Events.player_deactivated.emit()


func _on_add_building_exited() -> void:
	Events.add_building_exited.disconnect(_on_add_building_exited)
	
	Events.add_road_entered.emit()


func _on_add_road_exited() -> void:
	state_changed.emit("InactiveState")
	Events.add_road_exited.disconnect(_on_add_road_exited)
	base.end_turn()
