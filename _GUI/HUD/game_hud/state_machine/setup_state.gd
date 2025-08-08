extends State

func enter() -> void:
	Events.setup_entered.emit()
	Events.player_activated.emit()


func exit() -> void:
	Events.player_deactivated.emit()


func _on_settlement_built() -> void:
	pass


func _on_road_built() -> void:
	state_changed.emit("InactiveState")
