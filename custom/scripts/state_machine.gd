class_name StateMachine
extends Node

@export var base: Node

var states: Dictionary
var current_state: State

func _ready() -> void:
	for child in get_children():
		states[child.name] = child
		child.base = base
		child.state_changed.connect(_on_state_changed)
	set_starting_state()

func set_starting_state() -> void:
	current_state = get_child(0)
	current_state.enter()
	current_state.start_process()

func _process(delta: float) -> void:
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

func _on_state_changed(new_state: String) -> void:
	current_state.end_process()
	current_state.exit()
	states[new_state].enter()
	states[new_state].start_process()
	current_state = states[new_state]
