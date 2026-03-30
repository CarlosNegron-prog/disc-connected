extends Control


const MAIN_GAME_SCENE = "res://scenes/GameInfo6.tscn"

@onready var next: Button = $Button

func _ready() -> void:
	next.pressed.connect(_on_next_button_pressed)

func _on_next_button_pressed() -> void:
	print("Next clicked")
	get_tree().change_scene_to_file(MAIN_GAME_SCENE)
