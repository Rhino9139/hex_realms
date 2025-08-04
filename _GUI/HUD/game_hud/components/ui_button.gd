class_name UIButton
extends Button

static var BUTTONS: Array[UIButton]

static func DISABLE_UI() -> void:
	for i in BUTTONS:
		i.disabled = true

static func ENABLE_UI() -> void:
	for i in BUTTONS:
		i.disabled = false

func _ready() -> void:
	BUTTONS.append(self)
