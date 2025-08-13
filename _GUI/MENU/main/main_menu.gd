extends Menu

@export var host_button: Button
@export var join_button: Button
@export var name_input: LineEdit


func _ready() -> void:
	name_input.text = Main.PLAYER_NAME


func _on_host_pressed() -> void:
	host_button.disabled = true
	join_button.disabled = true
	Events.MENU_START.host_game_pressed.emit()


func _on_join_pressed() -> void:
	host_button.disabled = true
	join_button.disabled = true
	Events.MENU_START.join_game_pressed.emit() 


func _on_name_input_text_submitted(new_text: String) -> void:
	get_viewport().gui_get_focus_owner().release_focus()
	Events.MENU_START.local_name_changed.emit(new_text)
