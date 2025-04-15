extends Node3D

@export var h_pivot: Node3D
@export var v_pivot: Node3D
@export var cam: Camera3D

var orbiting: bool = false
var rotate_vec: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("orbit_cam"):
		orbiting = true
	elif event.is_action_released("orbit_cam"):
		orbiting = false
	elif event is InputEventMouseMotion and orbiting:
		rotate_vec = event.screen_relative / 3.0
		h_pivot.rotation_degrees.y -= rotate_vec.x
		v_pivot.rotation_degrees.x -= rotate_vec.y
		v_pivot.rotation_degrees.x = clamp(v_pivot.rotation_degrees.x, -70.0, -10.0)
	elif event.is_action_pressed("zoom_cam_in"):
		cam.position.z -= event.get_action_strength("zoom_cam_in") * 6.0
		cam.position.z = clamp(cam.position.z, 15, 90)
	elif event.is_action_pressed("zoom_cam_out"):
		cam.position.z += event.get_action_strength("zoom_cam_out") * 6.0
		cam.position.z = clamp(cam.position.z, 15, 90)
