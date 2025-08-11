@tool
extends EditorPlugin

var primary_todo: Array[String] = ["Get this working", "Step 4: Profit"]
var secondary_todo: Array[String]

var main_panel: VBoxContainer
var primary_list: VBoxContainer
var secondary_list: VBoxContainer


func _enter_tree() -> void:
	#Events.todo_primary_added.connect(_todo_primary_added)
	
	main_panel = VBoxContainer.new()
	main_panel.name = "TODO List"
	
	primary_list = VBoxContainer.new()
	primary_list.size_flags_vertical = Control.SIZE_EXPAND
	main_panel.add_child(primary_list)
	secondary_list = VBoxContainer.new()
	secondary_list.size_flags_vertical = Control.SIZE_EXPAND
	main_panel.add_child(secondary_list)
	
	for item in primary_todo:
		var l = Label.new()
		l.text = item
		primary_list.add_child(l)
	
	for item in secondary_todo:
		var l = Label.new()
		l.text = item
		secondary_list.add_child(l)
	
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, main_panel)


func _exit_tree() -> void:
	remove_control_from_docks(main_panel)


func _todo_primary_added(new_primary: String) -> void:
	primary_list.append(new_primary)
	refresh()


func refresh() -> void:
	for child in primary_list.get_children():
		child.queue_free()
	
	for child in secondary_list.get_children():
		child.queue_free()
	
	for item in primary_todo:
		var l = Label.new()
		l.text = item
		primary_list.add_child(l)
	
	for item in secondary_todo:
		var l = Label.new()
		l.text = item
		secondary_list.add_child(l)
