class_name PlayerCamera
extends Character

@export var h_pivot: Node3D
@export var v_pivot: Node3D
@export var cam: Camera3D

var orbiting: bool = false
var rotate_vec: Vector2 = Vector2.ZERO
var h_rot_target: float = 0.0
var v_rot_target: float = 45.0
var status_update: Callable = status_idle
var current_hover: Area3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("orbit_cam"):
		orbiting = true
	elif event.is_action_released("orbit_cam"):
		orbiting = false
	elif event is InputEventMouseMotion and orbiting:
		rotate_vec = event.screen_relative / 6.0
		h_pivot.rotation_degrees.y -= rotate_vec.x
		v_pivot.rotation_degrees.x -= rotate_vec.y
		v_pivot.rotation_degrees.x = clamp(v_pivot.rotation_degrees.x, -85.0, -10.0)
	elif event.is_action_pressed("zoom_cam_in"):
		cam.position.z -= event.get_action_strength("zoom_cam_in") * 6.0
		cam.position.z = clamp(cam.position.z, 15, 90)
	elif event.is_action_pressed("zoom_cam_out"):
		cam.position.z += event.get_action_strength("zoom_cam_out") * 6.0
		cam.position.z = clamp(cam.position.z, 15, 90)
	elif event.is_action_pressed("main_action"):
		status_update.call(0.0, true)


func _process(delta: float) -> void:
	status_update.call(delta, false)


func status_idle(_delta: float, _clicked: bool = false) -> void:
	pass


func status_hover(_delta: float, clicked: bool = false) -> void:
	update_hover_raycast(clicked)


func update_lerps(delta: float) -> void:
	h_pivot.rotation_degrees.y = lerp(h_pivot.rotation_degrees.y, h_rot_target, 25.0 * delta)
	v_pivot.rotation_degrees.x = lerp(v_pivot.rotation_degrees.x, v_rot_target, 25.0 * delta)
	v_pivot.rotation_degrees.x = clamp(v_pivot.rotation_degrees.x, -70.0, -10.0)


func update_hover_raycast(clicked: bool = false) -> void:
	var camera: Camera3D = cam
	var space_state: PhysicsDirectSpaceState3D = cam.get_world_3d().direct_space_state
	var screen_center: Vector2 = get_viewport().get_mouse_position()
	var origin: Vector3 = cam.project_ray_origin(screen_center)
	var end: Vector3 = origin + camera.project_ray_normal(screen_center) * 1000.0
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = false
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if result:
		var collider = result.get("collider")
		Events.selectable_hovered.emit(collider)
		if clicked:
			if collider is HexRegion:
				collider.move_robber.rpc()
			else:
				var id: int = multiplayer.get_unique_id()
				collider.build.rpc(id)
	else:
		Events.selectable_hovered.emit(null)


func change_to_hover() -> void:
	status_update = status_hover


func change_to_idle() -> void:
	status_update = status_idle
	Events.selectable_hovered.emit(null)
