class_name MainMenu
extends Control

const _PATH: String = "uid://w2srhsq0e6wx"

static var MASTER: MainMenu

@export var start_button: Button

static func CREATE() -> MainMenu:
	var new_menu: MainMenu = load(_PATH).instantiate()
	return new_menu

static func DESTROY() -> void:
	MASTER.queue_free()

func _init() -> void:
	MASTER = self

func _on_start_pressed() -> void:
	Game.BEGIN_MATCH.call_deferred()
