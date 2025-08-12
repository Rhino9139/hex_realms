class_name UIStateMachine
extends Node

enum States{INACTIVE, WAIT_SCREEN, SETUP, STANDARD}

var _state: UIState

var states: Dictionary[States, UIState] = {
	States.INACTIVE : ui_Inactive.new(),
	States.WAIT_SCREEN : ui_WaitScreen.new(),
	States.SETUP : ui_Setup.new(),
	States.STANDARD : ui_Standard.new(),
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
		Events.LOGIC_DOWN.start_next_turn.connect(_start_next_turn)
	
	
	func exit() -> void:
		Events.LOGIC_DOWN.start_next_turn.disconnect(_start_next_turn)
	
	
	func _start_next_turn(current_turn: int, current_round: int) -> void:
		var local_turn: int = Player.LOCAL_PLAYER.turn_index
		if current_turn != local_turn:
			return
		if current_round <= 2:
			state_changed.emit(States.SETUP)
		else:
			state_changed.emit(States.STANDARD)


class ui_WaitScreen extends UIState:
	
	func enter() -> void:
		pass
	
	
	func exit() -> void:
		pass


class ui_Setup extends UIState:
	
	func enter() -> void:
		Events.BOARD_END.make_building_available.emit(Hotspot.Type.EMPTY)
		Events.CHARACTER_END.activate_camera.emit()
	
	
	func exit() -> void:
		Events.CHARACTER_END.deactivate_camera.emit()
	
	
	func _on_add_building_exited() -> void:
		pass
	
	
	func _on_add_road_exited() -> void:
		Events.LOGIC_UP.player_turn_finished.emit()
		state_changed.emit(States.INACTIVE)


class ui_Standard extends UIState:
	pass
