class_name Game
extends Node

signal name_changed(new_name: String)

static var MASTER: Game

var game_name: String = "Default":
	set(new_value):
		game_name = new_value
		name_changed.emit(game_name)

static func GET_NAME() -> String:
	return MASTER.game_name

static func SET_NAME(new_name: String) -> void:
	MASTER.game_name = new_name

static func BEGIN_MATCH() -> void:
	MasterGUI.LEAVE_MENUS()
	Master3D.ADD_MAP()
	MasterGUI.ENTER_MATCH()

static func CONNECT_NAME_SIGNAL(player: Player) -> void:
	MASTER.name_changed.connect(player._on_name_changed)

func _init() -> void:
	MASTER = self

func _ready() -> void:
	MasterGUI.START_MENU()
