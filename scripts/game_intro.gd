extends Control

const MAIN_GAME_SCENE = "res://scenes/game.tscn"

@onready var play: Button = $Button
@onready var quit: Button = $Button2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play.pressed.connect(_on_play_button_pressed)
	quit.pressed.connect(_on_quit_button_pressed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_play_button_pressed() -> void:
	print("Play clicked")
	get_tree().change_scene_to_file(MAIN_GAME_SCENE)

func _on_quit_button_pressed() -> void:
	print("Quit clicked")
	get_tree().quit()
