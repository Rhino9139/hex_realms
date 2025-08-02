extends Menu

@export var start_button: Button
@export var host_button: Button
@export var join_button: Button
@export var name_input: LineEdit


func _ready() -> void:
	name_input.text = Main.PLAYER_NAME


func _on_start_pressed() -> void:
	EventBus.host_match_started.emit()


func _on_host_pressed() -> void:
	EventBus.server_requested.emit()
	host_button.disabled = true
	join_button.disabled = true
	start_button.disabled = false


func _on_join_pressed() -> void:
	EventBus.client_requested.emit()
	host_button.disabled = true
	join_button.disabled = true


func _on_name_input_text_submitted(new_text: String) -> void:
	get_viewport().gui_get_focus_owner().release_focus()
	EventBus.local_name_changed.emit(new_text)
