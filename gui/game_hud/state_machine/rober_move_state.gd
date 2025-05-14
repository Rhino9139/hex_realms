extends State

func enter() -> void:
	get_tree().call_group("RobberAbsent", "make_available")
