extends VBoxContainer

func _on_refresh_timer_timeout() -> void:
	for child in get_children():
		if child is PlayerLabel:
			child.queue_free()
	for player in PlayerManager.GET_PLAYERS():
		var new_label: PlayerLabel = PlayerLabel.new()
		new_label.player_id = player.player_id
		new_label.display_name = player.player_name
		new_label.modulate = player.player_color
		add_child(new_label)
