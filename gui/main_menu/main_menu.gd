class_name MainMenu
extends Control

const _PATH: String = "uid://w2srhsq0e6wx"

static var MASTER: MainMenu

@export var start_button: Button
@export var host_button: Button
@export var join_button: Button
@export var name_input: LineEdit
@export var wait_screen: TextureRect

var tween: Tween

static func CREATE() -> MainMenu:
	var new_menu: MainMenu = load(_PATH).instantiate()
	return new_menu

static func DESTROY() -> void:
	MASTER.queue_free()

func _init() -> void:
	MASTER = self

func _ready() -> void:
	name_input.text = Game.GET_NAME()

func _on_start_pressed() -> void:
	wait_screen.visible = true
	
	Game.BEGIN_MATCH_REQUEST.call_deferred()

func _on_host_pressed() -> void:
	MultiplayerManager.CREATE_SERVER_HOST()
	host_button.disabled = true
	join_button.disabled = true
	start_button.disabled = false

func _on_join_pressed() -> void:
	MultiplayerManager.CREATE_CLIENT()
	host_button.disabled = true
	join_button.disabled = true

func _on_name_input_text_submitted(new_text: String) -> void:
	get_viewport().gui_get_focus_owner().release_focus()
	Game.SET_NAME(new_text)
