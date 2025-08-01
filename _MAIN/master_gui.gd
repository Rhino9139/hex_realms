class_name MasterGUI
extends Control


var current_menu: Menu


func _ready() -> void:
	EventBus.program_started.connect(_on_program_started)
	EventBus.match_started.connect(_on_match_started)


func _on_program_started() -> void:
	if current_menu:
		current_menu.queue_free()
	
	current_menu = Menu.CREATE(Menu.Types.MAIN)
	add_child(current_menu)


func _on_match_started() -> void:
	if current_menu:
		current_menu.queue_free()
	
	add_child(Screen.CREATE(Screen.Headers.TURN_ORDER))
