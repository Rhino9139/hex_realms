class_name Master3D
extends Node3D


@export var board: Board
@export var character: Character


func _ready() -> void:
	EventTower.add_board_requested.connect(_on_add_board_requested)
	EventTower.destroy_board_requested.connect(_on_destroy_board_requested)
	EventTower.generate_board_requested.connect(_on_generate_board_requested)


func _on_add_board_requested() -> void:
	board.add_board()


func _on_destroy_board_requested() -> void:
	board.destroy_board()
	character.destroy_camera()


func _on_generate_board_requested() -> void:
	board.destroy_board()
	board.generate_board()
	character.add_camera()
