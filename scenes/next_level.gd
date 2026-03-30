extends Node2D

@export var finish_scene: String = "res://scenes/GameIntro.tscn"

var chest_opened := false
var door_used := false

@onready var chest_interactable: Area2D = $Chest/interactable
@onready var chest_sprite: Sprite2D = $Chest/Sprite2D
@onready var exit_door: StaticBody2D = $ExitDoor
@onready var hint_label: Label = $UI/HintLabel

func _ready() -> void:
	add_to_group("game_manager")
	var _music := AudioStreamPlayer.new()
	_music.stream = load("res://game music/tech.mp3")
	_music.stream.loop = true
	add_child(_music)
	_music.play()

	chest_interactable.interact = _on_chest_interact
	chest_interactable.interact_name = "Open Chest"
	chest_interactable.is_interactable = true
	hint_label.text = "Find and open the chest."

func _on_chest_interact() -> void:
	if chest_opened:
		return

	chest_opened = true
	chest_interactable.is_interactable = false
	chest_interactable.interact_name = "Chest (Opened)"

	var open_tex := load("res://map/chest/chest_open.png")
	if chest_sprite and open_tex:
		chest_sprite.texture = open_tex

	if exit_door.has_method("unlock"):
		exit_door.unlock()

	hint_label.text = "Door unlocked. Go to the exit."
