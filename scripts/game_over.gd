extends Control


const MAIN_GAME_SCENE = "res://scenes/game.tscn"

@onready var play_again: Button = $Button
@onready var quit: Button = $Button2

func _ready() -> void:
	# This connects the "pressed" signal of the buttons to your functions below
	play_again.pressed.connect(_on_play_again_button_pressed)
	quit.pressed.connect(_on_quit_button_pressed)

func _on_play_again_button_pressed() -> void:
	print("Play again clicked")
	get_tree().change_scene_to_file(MAIN_GAME_SCENE)


func _on_quit_button_pressed() -> void:
	print("Quit clicked")
	get_tree().quit()
