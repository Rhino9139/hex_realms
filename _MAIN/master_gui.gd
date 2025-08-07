class_name MasterGUI
extends Control

@export var menu: Menu
@export var hud: HUD
@export var screen: Screen


func _ready() -> void:
	Events.game_opened.connect(_on_game_opened)
	Events.host_match_started.connect(_on_host_match_started)
	Events.turn_order_created.connect(_on_turn_order_created)


func _on_game_opened() -> void:
	menu.add_menu(Menu.Header.MAIN)


func _on_host_match_started() -> void:
	menu.clear_menu()
	screen.add_screen(Screen.Header.TURN_ORDER)


func _on_turn_order_created() -> void:
	screen.clear_screen()
	hud.add_hud(HUD.Header.GAME)
	hud.add_hud(HUD.Header.PLAYER_RESOURCES)
