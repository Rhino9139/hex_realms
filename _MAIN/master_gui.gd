class_name MasterGUI
extends Control

@export var menu: Menu
@export var hud: HUD
@export var screen: Screen


func _ready() -> void:
	Events.game_started.connect(_on_game_started)
	Events.board_shared.connect(_on_board_shared)
	Events.turn_order_created.connect(_on_turn_order_created)


func _on_game_started() -> void:
	menu.add_menu(Menu.Header.MAIN)


func _on_board_shared() -> void:
	menu.clear_menu()
	screen.add_screen(Screen.Header.TURN_ORDER)


func _on_turn_order_created() -> void:
	hud.add_hud(HUD.Header.GAME)
