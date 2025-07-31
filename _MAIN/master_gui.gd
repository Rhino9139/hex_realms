class_name MasterGUI
extends Control

static var MASTER: MasterGUI


static func START_MENU() -> void:
	MASTER.add_main_menu()


static func LEAVE_MENUS() -> void:
	for child in MASTER.get_children():
		child.queue_free()


static func ENTER_MATCH() -> void:
	MASTER.add_game_hud()


static func ADD_SCREEN(new_screen: Screen) -> void:
	MASTER.add_child(new_screen)


func _init() -> void:
	MASTER = self


func add_main_menu() -> void:
	add_child(MainMenu.CREATE())


func add_game_hud() -> void:
	add_child(GameHUD.CREATE())
