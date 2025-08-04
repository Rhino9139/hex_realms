extends Menu

@export var host_button: Button
@export var join_button: Button
@export var name_input: LineEdit


func _ready() -> void:
	name_input.text = Main.PLAYER_NAME


func _on_host_pressed() -> void:
	EventTower.server_requested.emit()
	host_button.disabled = true
	join_button.disabled = true
	menu_changed.emit(Header.LOBBY)


func _on_join_pressed() -> void:
	EventTower.client_requested.emit()
	host_button.disabled = true
	join_button.disabled = true


func _on_name_input_text_submitted(new_text: String) -> void:
	get_viewport().gui_get_focus_owner().release_focus()
	EventTower.local_name_changed.emit(new_text)
