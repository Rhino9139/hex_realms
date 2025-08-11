class_name UIStateMachine
extends Node

enum States{INACTIVE, ACTIVE, WAIT_SCREEN}

var _state: UIState

var states: Dictionary[States, UIState] = {
	States.INACTIVE : ui_Inactive.new(),
	States.ACTIVE : ui_Active.new(),
	States.WAIT_SCREEN : ui_WaitScreen.new(),
}


func _enter_tree():
	_state = states[States.INACTIVE]
	_state.state_changed.connect(_on_state_changed)


func _ready():
	_state.enter()


func _on_state_changed(new_state: States) -> void:
	_state.exit()
	_state.state_changed.disconnect(_on_state_changed)
	_state = states[new_state]
	_state.state_changed.connect(_on_state_changed)
	_state.enter()


class UIState:
	
	signal state_changed(next_state: StringName)
	
	
	func enter() -> void:
		pass
	
	
	func exit() -> void:
		pass


class ui_Inactive extends UIState:
	
	func enter() -> void:
		pass
	
	
	func exit() -> void:
		pass


class ui_Active extends UIState:
	
	enum SubState{SETUP, STANDARD}
	
	func enter() -> void:
		pass
	
	
	func exit() -> void:
		pass


class ui_WaitScreen extends UIState:
	
	func enter() -> void:
		pass
	
	
	func exit() -> void:
		pass


class ui_Setup extends UIState:
	
	func enter() -> void:
		Events.add_building_exited.connect(_on_add_building_exited)
		Events.add_road_exited.connect(_on_add_road_exited)
		Events.add_building_entered.emit(Hotspot.Type.EMPTY)
		Events.player_activated.emit()
	
	
	func exit() -> void:
		Events.player_deactivated.emit()
	
	
	func _on_add_building_exited() -> void:
		Events.add_building_exited.disconnect(_on_add_building_exited)
		
		Events.add_road_entered.emit()
	
	
	func _on_add_road_exited() -> void:
		state_changed.emit(States.INACTIVE)
		Events.add_road_exited.disconnect(_on_add_road_exited)
		Events.turn_finished.emit()
