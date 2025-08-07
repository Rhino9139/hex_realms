class_name MasterGUI
extends Control

@export var menu: Menu
@export var hud: HUD
@export var screen: Screen


func _ready() -> void:
	EventTower.game_opened.connect(_on_game_opened)


func _on_game_opened() -> void:
	menu.add_menu(Menu.Header.MAIN)
