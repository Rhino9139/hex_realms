class_name MainMenu
extends Control

const _PATH: String = "uid://w2srhsq0e6wx"

static var MASTER: MainMenu

@export var start_button: Button
@export var pivot_hex: Sprite2D

var tween: Tween

static func CREATE() -> MainMenu:
	var new_menu: MainMenu = load(_PATH).instantiate()
	return new_menu

static func DESTROY() -> void:
	MASTER.queue_free()

func _init() -> void:
	MASTER = self

func rotate_hex() -> void:
	if tween: 
		tween.kill()
	tween = create_tween()
	tween.tween_property(pivot_hex, "rotation_degrees", pivot_hex.rotation_degrees + 60.0, 1.0)

func _on_start_pressed() -> void:
	Game.BEGIN_MATCH.call_deferred()

func _on_host_pressed() -> void:
	MultiplayerManager.CREATE_SERVER_HOST()

func _on_join_pressed() -> void:
	MultiplayerManager.CREATE_CLIENT()
