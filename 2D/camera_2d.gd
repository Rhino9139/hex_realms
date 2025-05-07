extends Camera2D

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_A):
		global_position.x -= 200 * delta
	if Input.is_key_pressed(KEY_D):
		global_position.x += 200 * delta
	if Input.is_key_pressed(KEY_W):
		global_position.y -= 200 * delta
	if Input.is_key_pressed(KEY_S):
		global_position.y += 200 * delta
