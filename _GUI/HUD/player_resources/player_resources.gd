class_name PlayerResources
extends Node

@export var bank_trade_panel: Panel
@export var trade_accept_button: Button


func _ready() -> void:
	Events.bank_trade_started.connect(_on_bank_trade_started)
	Events.bank_trade_completed.connect(_on_bank_trade_completed)


func _on_bank_trade_started() -> void:
	bank_trade_panel.visible = true


func _on_bank_trade_completed() -> void:
	bank_trade_panel.visible = false


func _on_trade_accept_pressed() -> void:
	Events.bank_trade_completed.emit()
