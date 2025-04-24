class_name Game
extends Node

static var MASTER: Game

static func START_GAME() -> void:
	MasterGUI.LEAVE_MENUS()
	Master3D.ADD_MAP()

func _init() -> void:
	MASTER = self

func _ready() -> void:
	MasterGUI.ADD_MAIN_MENU()
