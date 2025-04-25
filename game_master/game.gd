class_name Game
extends Node

static var MASTER: Game

static func BEGIN_MATCH() -> void:
	MasterGUI.LEAVE_MENUS()
	Master3D.ADD_MAP()
	MasterGUI.ENTER_MATCH()

func _init() -> void:
	MASTER = self

func _ready() -> void:
	MasterGUI.START_MENU()
