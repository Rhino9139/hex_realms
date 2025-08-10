class_name Character
extends Node3D

enum Header{PLAYER_CAMERA}

const _PATHS: Dictionary[Header, String] = {
	Header.PLAYER_CAMERA : "uid://dqts8cum5xryh"
}

var current_camera: PlayerCamera


func _ready() -> void:
	Events.CHARACTER_END.add_camera.connect(_add_camera)
	Events.CHARACTER_END.destroy_camera.connect(_destroy_camera)
	Events.CHARACTER_END.activate_camera.connect(_activate_camera)
	Events.CHARACTER_END.deactivate_camera.connect(_deactivate_camera)


func _add_camera() -> void:
	share_add_camera.rpc()


@rpc("any_peer", "call_local")
func share_add_camera() -> void:
	if current_camera:
		return
	else:
		current_camera = load(_PATHS[Header.PLAYER_CAMERA]).instantiate()
		add_child(current_camera)


func _destroy_camera() -> void:
	share_destroy_camera.rpc()


@rpc("any_peer", "call_local")
func share_destroy_camera() -> void:
	if current_camera:
		current_camera.queue_free()


func _activate_camera() -> void:
	if current_camera:
		current_camera.change_to_hover()


func _deactivate_camera() -> void:
	if current_camera:
		current_camera.change_to_idle()
