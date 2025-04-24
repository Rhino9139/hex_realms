class_name MasterGUI
extends Control

static var MASTER: MasterGUI

static func ADD_MAIN_MENU() -> void:
	MASTER.add_child(MainMenu.CREATE())

static func REMOVE_MAIN_MENU() -> void:
	MainMenu.REMOVE()

static func LEAVE_MENUS() -> void:
	for child in MASTER.get_children():
		child.queue_free()

func _init() -> void:
	MASTER = self
