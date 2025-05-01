class_name Character
extends Node3D

const _PATH: String = "uid://dqts8cum5xryh"

@export var h_pivot: Node3D
@export var v_pivot: Node3D
@export var cam: Camera3D

var orbiting: bool = false
var rotate_vec: Vector2 = Vector2.ZERO
var h_rot_target: float = 0.0
var v_rot_target: float = 0.0

static func CREATE() -> Character:
	var new_char: Character = load(_PATH).instantiate()
	return new_char

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("orbit_cam"):
		orbiting = true
	elif event.is_action_released("orbit_cam"):
		orbiting = false
	elif event is InputEventMouseMotion and orbiting:
		rotate_vec = event.screen_relative / 6.0
		h_rot_target -= rotate_vec.x
		v_rot_target -= rotate_vec.y
	elif event.is_action_pressed("zoom_cam_in"):
		cam.position.z -= event.get_action_strength("zoom_cam_in") * 6.0
		cam.position.z = clamp(cam.position.z, 15, 90)
	elif event.is_action_pressed("zoom_cam_out"):
		cam.position.z += event.get_action_strength("zoom_cam_out") * 6.0
		cam.position.z = clamp(cam.position.z, 15, 90)

func _process(delta: float) -> void:
	update_lerps(delta)

func update_lerps(delta: float) -> void:
	h_pivot.rotation_degrees.y = lerp(h_pivot.rotation_degrees.y, h_rot_target, 25.0 * delta)
	v_pivot.rotation_degrees.x = lerp(v_pivot.rotation_degrees.x, v_rot_target, 25.0 * delta)
	v_pivot.rotation_degrees.x = clamp(v_pivot.rotation_degrees.x, -70.0, -10.0)

func update_hover_raycast() -> Dictionary:
	var camera: Camera3D = cam
	var space_state: PhysicsDirectSpaceState3D = cam.get_world_3d().direct_space_state
	var screen_center: Vector2 = get_viewport().get_mouse_position()
	var origin: Vector3 = cam.project_ray_origin(screen_center)
	var end: Vector3 = origin + camera.project_ray_normal(screen_center) * 1000.0
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = false
	query.collide_with_areas = true
	return space_state.intersect_ray(query)
