extends State

func enter() -> void:
	Robber.GET_ROBBER().robber_moved.connect(_on_robber_moved)
	Character.SWAP_TO_HOVER()
	get_tree().call_group("RobberAbsent", "make_available")

func exit() -> void:
	get_tree().call_group("RobberAbsent", "make_unavailable")
	Robber.GET_ROBBER().robber_moved.disconnect(_on_robber_moved)
	Character.SWAP_T0_IDLE()

func _on_robber_moved() -> void:
	state_changed.emit("ActiveState")
