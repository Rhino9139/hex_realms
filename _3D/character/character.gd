class_name Character
extends Node3D

enum Header{PLAYER_CAMERA}

const _PATHS: Dictionary[Header, String] = {
	Header.PLAYER_CAMERA : "uid://dqts8cum5xryh"
}

var current_camera: Character


func _ready() -> void:
	EventTower.add_player_camera_requested.connect(_on_add_player_camera_requested)
	EventTower.destroy_player_camera_requested.connect(_on_destroy_player_camera_requested)


func _on_add_player_camera_requested() -> void:
	if current_camera:
		current_camera.queue_free()
	current_camera = load(_PATHS[Header.PLAYER_CAMERA]).instantiate()
	add_child(current_camera)


func _on_destroy_player_camera_requested() -> void:
	if current_camera:
		current_camera.queue_free()
