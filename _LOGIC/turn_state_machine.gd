class_name UIStateMachine
extends Node
@warning_ignore_start("unused_signal")
enum States{INACTIVE, WAIT_ROLL, SETUP, STANDARD}
enum Substates{BUILD, CONFIRM_BUY}

var _state: UIState

var states: Dictionary[States, UIState] = {
	States.INACTIVE : ui_Inactive.new(),
	States.WAIT_ROLL : ui_WaitRoll.new(),
	States.SETUP : ui_Setup.new(),
	States.STANDARD : ui_Standard.new()
}


func _enter_tree():
	_state = states[States.INACTIVE]
	_state.state_changed.connect(_on_state_changed)


func _ready():
	_state.enter()


func _on_state_changed(next_state: States) -> void:
	_state.exit()
	_state.state_changed.disconnect(_on_state_changed)
	_state = states[next_state]
	_state.state_changed.connect(_on_state_changed)
	_state.enter()


class UIState:
	
	signal state_changed(next_state: States)
	signal substate_exited(hotspot_type: Hotspot.Type)
	
	var substate: UIState
	
	func enter() -> void:
		pass
	
	
	func exit() -> void:
		pass


class ui_Inactive extends UIState:
	
	func enter() -> void:
		Events.LOGIC_DOWN.start_next_turn.connect(_start_next_turn)
		
		Events.HUD_END.disable_buy_button.emit()
	
	
	func exit() -> void:
		Events.LOGIC_DOWN.start_next_turn.disconnect(_start_next_turn)
	
	
	func _start_next_turn(current_turn: int, current_round: int, LP_turn_index) -> void:
		if current_turn != LP_turn_index:
			return
		if current_round <= 2:
			state_changed.emit(States.SETUP)
		else:
			state_changed.emit(States.WAIT_ROLL)


class ui_WaitRoll extends UIState:
	
	func enter() -> void:
		Events.HUD_END.enable_dice_roll.emit()
		Events.LOGIC_DOWN.go_to_standard.connect(_go_to_standard)
	
	
	func exit() -> void:
		Events.LOGIC_DOWN.go_to_standard.disconnect(_go_to_standard)
	
	
	func _go_to_standard() -> void:
		state_changed.emit(States.STANDARD)


class ui_Setup extends UIState:
	
	func enter() -> void:
		substate = ui_Build.new()
		substate.hotspot_type = Hotspot.Type.EMPTY
		substate.has_cost = false
		substate.substate_exited.connect(_substate_exited)
		substate.enter()
	
	
	func _substate_exited(hotspot_type: Hotspot.Type) -> void:
		substate.exit()
		substate = null
		if hotspot_type == Hotspot.Type.EMPTY:
			substate = ui_Build.new()
			substate.hotspot_type = Hotspot.Type.ROAD
			substate.has_cost = false
			substate.substate_exited.connect(_substate_exited)
			substate.enter()
		else:
			state_changed.emit(States.INACTIVE)
			Events.LOGIC_UP.player_turn_finished.emit()


class ui_Standard extends UIState:
	
	func enter() -> void:
		Events.HUD_START.buy_button_toggled_on.connect(_buy_button_toggled_on)
		Events.HUD_START.buy_button_toggled_off.connect(_buy_button_toggled_off)
		Events.HUD_START.action_card_clicked.connect(_action_card_clicked)
		Events.LOGIC_DOWN.go_to_inactive.connect(_go_to_inactive)
		Events.PLAYER_START.resources_changed.connect(_resources_changed)
		Events.HUD_END.enable_buy_button.emit()
		Events.HUD_END.enable_end_turn.emit()
		Events.CHARACTER_END.activate_camera.emit()
		
		
	
	
	func exit() -> void:
		Events.HUD_START.buy_button_toggled_on.disconnect(_buy_button_toggled_on)
		Events.HUD_START.buy_button_toggled_off.disconnect(_buy_button_toggled_off)
		Events.HUD_START.action_card_clicked.disconnect(_action_card_clicked)
		Events.LOGIC_DOWN.go_to_inactive.disconnect(_go_to_inactive)
		Events.PLAYER_START.resources_changed.disconnect(_resources_changed)
		Events.HUD_END.toggle_buy_button_off.emit()
		Events.HUD_END.disable_buy_button.emit()
		Events.HUD_END.disable_confirm_buy.emit()
		Events.BOARD_END.make_hotspot_unavailable.emit()
		Events.CHARACTER_END.deactivate_camera.emit()
	
	
	func _buy_button_toggled_on(button_type: BuyButton.Type) -> void:
		match button_type:
			BuyButton.Type.SETTLEMENT:
				substate = ui_Build.new()
				substate.hotspot_type = Hotspot.Type.EMPTY
				substate.substate_exited.connect(_substate_exited)
				substate.enter()
			BuyButton.Type.CASTLE:
				substate = ui_Build.new()
				substate.hotspot_type = Hotspot.Type.SETTLEMENT
				substate.substate_exited.connect(_substate_exited)
				substate.enter()
			BuyButton.Type.ROAD:
				substate = ui_Build.new()
				substate.hotspot_type = Hotspot.Type.ROAD
				substate.substate_exited.connect(_substate_exited)
				substate.enter()
			BuyButton.Type.CARD:
				substate = ui_ConfirmBuy.new()
				substate.substate_exited.connect(_substate_exited)
				substate.enter()
			BuyButton.Type.BANK_TRADE:
				pass
			BuyButton.Type.PLAYER_TRADE:
				pass
	
	
	func _buy_button_toggled_off() -> void:
		Events.BOARD_END.make_hotspot_unavailable.emit()
		Events.HUD_END.disable_confirm_buy.emit()
		if substate:
			substate.exit()
			substate = null
	
	
	func _substate_exited(_hotspot_type: Hotspot.Type) -> void:
		Events.HUD_END.toggle_buy_button_off.emit()
		Events.HUD_END.enable_buy_button.emit()
		if substate:
			substate.exit()
			substate = null
	
	
	func _go_to_inactive() -> void:
		state_changed.emit(States.INACTIVE)
	
	
	func _resources_changed(_new_resources: Dictionary[Global.Resources, int], _player_id: int) -> void:
		Events.HUD_END.enable_buy_button.emit()
	
	
	func _action_card_clicked(card_type: Global.ActionCardType) -> void:
		print("action card clicked")
		_substate_exited(Hotspot.Type.EMPTY)
		match card_type:
			Global.ActionCardType.KNIGHT:
				#TODO go to robber state
				pass
			Global.ActionCardType.VICTORY_POINT:
				pass
			Global.ActionCardType.YEAR_OF_PLENTY:
				pass
			Global.ActionCardType.MONOPOLY:
				pass
			Global.ActionCardType.FREE_ROADS:
				pass
		Events.PLAYER_END.use_action_card.emit(card_type)


class ui_Build extends UIState:
	
	var hotspot_type: Hotspot.Type
	var has_cost: bool = true
	
	func enter() -> void:
		Events.CHARACTER_START.hotspot_hovered.connect(_hotspot_hovered)
		Events.CHARACTER_START.hotspot_clicked.connect(_hotspot_clicked)
		Events.BOARD_START.building_added.connect(_building_added)
		Events.CHARACTER_END.activate_camera.emit()
		var local_player: Player = Player.LOCAL_PLAYER
		var message: Hotspot.Message = Hotspot.Message.new(
				local_player,
				hotspot_type,
				null,
				MatchLogic.CURRENT_ROUND)
		Events.BOARD_END.make_hotspot_available.emit(message)
	
	
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
		var message: Hotspot.Message = Hotspot.Message.new(
				player,
				hotspot.hotspot_type,
				hotspot, 
				MatchLogic.CURRENT_ROUND
				)
		Events.BOARD_END.click_hotspot.emit(message)
	
	
	func _building_added(_hotspot: Hotspot) -> void:
		Events.BOARD_END.make_hotspot_unavailable.emit()
		if has_cost:
			Events.PLAYER_END.buy_hotspot.emit(hotspot_type)
		substate_exited.emit(hotspot_type)


class ui_ConfirmBuy extends UIState:
	
	func enter() -> void:
		Events.HUD_START.card_buy_confirmed.connect(_card_buy_confirmed)
		
		Events.HUD_END.enable_confirm_buy.emit()
	
	
	func exit() -> void:
		Events.HUD_START.card_buy_confirmed.disconnect(_card_buy_confirmed)
		
		Events.HUD_END.disable_confirm_buy.emit()
	
	
	func _card_buy_confirmed() -> void:
		Events.LOGIC_UP.action_card_bought.emit()
		substate_exited.emit(Hotspot.Type.EMPTY)
