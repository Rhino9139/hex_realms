class_name Port
extends Node3D

static var ports: Array[Port] = []

func _init() -> void:
	ports.append(self)
