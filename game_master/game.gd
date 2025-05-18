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

static func BEGIN_MATCH_REQUEST() -> void:
	MASTER.begin_match.rpc()

static func CONNECT_NAME_SIGNAL(player: Player) -> void:
	MASTER.name_changed.connect(player._on_name_changed)

func _init() -> void:
	MASTER = self

func _ready() -> void:
	
	if OS.get_cmdline_args().size() > 1:
		var new_name: String = OS.get_cmdline_args()[1]
		var new_pos: Vector2 = Vector2(100, 100)
		Game.SET_NAME(new_name)
	
		match new_name:
			"Valmar":
				new_pos = Vector2(4000, 200)
			"Gurdwynn":
				new_pos = Vector2(200, 200)
			"Kai":
				new_pos = Vector2(2400, 200)
		
		DisplayServer.window_set_position(new_pos)
	MasterGUI.START_MENU()

@rpc("any_peer", "call_local")
func begin_match() -> void:
	MasterGUI.LEAVE_MENUS()
	Master3D.ADD_MAP()
	
