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
	
	
	func _start_next_turn(current_turn: int, current_round: int, LP_turn_index) -> void:
		if current_turn != LP_turn_index:
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
		Events.CHARACTER_START.hotspot_hovered.connect(_hotspot_hovered)
		Events.CHARACTER_START.hotspot_clicked.connect(_hotspot_clicked)
		Events.BOARD_START.building_added.connect(_building_added)
		
		var message: Hotspot.Message = Hotspot.Message.new(null, Hotspot.Type.EMPTY, null)
		Events.BOARD_END.make_hotspot_available.emit(message)
		Events.CHARACTER_END.activate_camera.emit()
	
	
	func exit() -> void:
		Events.CHARACTER_START.hotspot_hovered.disconnect(_hotspot_hovered)
		Events.CHARACTER_START.hotspot_clicked.disconnect(_hotspot_clicked)
		Events.BOARD_START.building_added.disconnect(_building_added)
		
		Events.CHARACTER_END.deactivate_camera.emit()
	
	
	func _hotspot_hovered(hotspot: Hotspot) -> void:
		var local_player: Player = Player.LOCAL_PLAYER
		var message: Hotspot.Message = \
				Hotspot.Message.new(local_player, Hotspot.Type.EMPTY, hotspot)
		Events.BOARD_END.show_hover.emit(message)
	
	
	func _hotspot_clicked(player: Player, hotspot: Hotspot) -> void:
		var message: Hotspot.Message = \
				Hotspot.Message.new(player, Hotspot.Type.EMPTY, hotspot)
		Events.BOARD_END.click_hotspot.emit(message)
	
	
	func _building_added(hotspot: Hotspot) -> void:
		Events.BOARD_END.make_hotspot_unavailable.emit()
		if hotspot.hotspot_type == Hotspot.Type.SETTLEMENT:
			var message: Hotspot.Message = Hotspot.Message.new(null, Hotspot.Type.ROAD, null)
			Events.BOARD_END.make_hotspot_available.emit(message)
		else:
			state_changed.emit(States.INACTIVE)
			Events.LOGIC_UP.player_turn_finished.emit()


class ui_Standard extends UIState:
	
	func enter() -> void:
		pass
	
	
	func exit() -> void:
		pass
