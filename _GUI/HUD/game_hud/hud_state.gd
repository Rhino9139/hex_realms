class_name UIStateMachine
extends Node

enum States{INACTIVE, SETUP, WAIT_SCREEN, ACTIVE}

var _state: UIState

var states: Dictionary[States, UIState] = {
	States.INACTIVE : ui_Inactive.new(),
	States.SETUP : ui_Setup.new(),
	States.WAIT_SCREEN : ui_WaitScreen.new(),
	States.ACTIVE : ui_Active.new(),
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
		Events.player_turn_started.connect(_on_player_turn_started)
		Events.player_deactivated.emit()
	
	
	func exit() -> void:
		Events.player_turn_started.disconnect(_on_player_turn_started)
	
	
	func _on_player_turn_started() -> void:
		pass
		#if Player.LOCAL_PLAYER.turn_index != MatchManager.current_turn:
			#return
		#if MatchManager.current_round <= 2:
			#state_changed.emit(States.SETUP)
		#else:
			#Events.roll_enabled.emit()
			#state_changed.emit(States.WAIT_SCREEN)


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


class ui_WaitScreen extends UIState:
	
	func enter() -> void:
		Events.screen_task_completed.connect(_on_screen_task_completed)
	
	
	func exit() -> void:
		Events.screen_task_completed.disconnect(_on_screen_task_completed)
	
	
	func _on_screen_task_completed() -> void:
		state_changed.emit(States.ACTIVE)


class ui_Active extends UIState:
	
	func enter() -> void:
		Events.player_ui_enabled.emit()
		Events.player_activated.emit()
	
	
	func exit() -> void:
		Events.player_ui_disabled.emit()
		Events.player_deactivated.emit()
