class_name Character
extends Node3D

enum Header{PLAYER_CAMERA}

const _PATHS: Dictionary[Header, String] = {
	Header.PLAYER_CAMERA : "uid://dqts8cum5xryh"
}

var current_camera: PlayerCamera


func add_camera() -> void:
	if current_camera:
		return
	current_camera = load(_PATHS[Header.PLAYER_CAMERA]).instantiate()
	add_child(current_camera)


func destroy_camera() -> void:
	if current_camera:
		current_camera.queue_free()


func activate_camera() -> void:
	if current_camera:
		current_camera.change_to_hover()


func deactivate_camera() -> void:
	if current_camera:
		current_camera.change_to_idle()
