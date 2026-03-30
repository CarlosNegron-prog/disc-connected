extends Control


const MAIN_GAME_SCENE = "res://scenes/game.tscn"
const GAME_OVER_SFX = preload("res://game music/game_over_sound.mp3")

@onready var play_again: Button = $Button
@onready var quit: Button = $Button2
@onready var quit_x: Button = $Button3

func _ready() -> void:
	var sfx := AudioStreamPlayer.new()
	sfx.stream = GAME_OVER_SFX
	sfx.bus = "Master"
	add_child(sfx)
	sfx.play()

	play_again.pressed.connect(_on_play_again_button_pressed)
	quit.pressed.connect(_on_quit_button_pressed)
	quit_x.pressed.connect(_on_quit_button_pressed)

func _on_play_again_button_pressed() -> void:
	print("Play again clicked")
	get_tree().change_scene_to_file(MAIN_GAME_SCENE)


func _on_quit_button_pressed() -> void:
	print("Quit clicked")
	get_tree().quit()
