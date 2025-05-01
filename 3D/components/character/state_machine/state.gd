class_name State
extends Node

signal state_changed(next_state: State)

var base: Character

func _init() -> void:
	process_mode = PROCESS_MODE_DISABLED

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func start_process() -> void:
	process_mode = PROCESS_MODE_INHERIT

func end_process() -> void:
	process_mode = PROCESS_MODE_DISABLED

func dummy() -> void:
	state_changed.emit(null)
