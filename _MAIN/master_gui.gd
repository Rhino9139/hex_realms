class_name MasterGUI
extends Control

@export var menu: Menu
@export var hud: HUD
@export var screen: Screen


#func _ready() -> void:
	#Events.host_match_started.connect(_on_host_match_started)
	#Events.turn_order_created.connect(_on_turn_order_created)
	#Events.roll_requested.connect(_on_roll_requested)
	#Events.dice_roll_completed.connect(_on_dice_roll_completed)


func _on_host_match_started() -> void:
	server_start_match.rpc()


@rpc("authority", "call_local")
func server_start_match() -> void:
	menu.clear_menu()
	screen.add_screen(Screen.Header.TURN_ORDER)


func _on_turn_order_created() -> void:
	screen.clear_screen()
	hud.add_hud(HUD.Header.PLAYER_RESOURCES)
	hud.add_hud(HUD.Header.GAME)
	Events.player_turn_started.emit()


func _on_roll_requested() -> void:
	var die_1: int = randi_range(1, 6)
	var die_2: int = randi_range(1, 6)
	share_roll_dice.rpc(die_1, die_2)


@rpc("any_peer", "call_local")
func share_roll_dice(new_die_1: int, new_die_2: int) -> void:
	screen.add_screen(Screen.Header.MAIN_ROLL)
	screen.current_screen.roll_dice(new_die_1, new_die_2)


func _on_dice_roll_completed(_total: int) -> void:
	screen.clear_screen()
