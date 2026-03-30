extends Node2D


@export var finish_scene: String = "res://scenes/GameIntro.tscn"

var chest_opened := false
var door_used := false

@onready var chest_interactable: Area2D = $Chest/interactable
@onready var chest_sprite: Sprite2D = $Chest/ChestSprite
@onready var exit_door: StaticBody2D = $ExitDoor

func _ready() -> void:
	add_to_group("game_manager")
	chest_interactable.interact = _on_chest_interact
	chest_interactable.interact_name = "Open Chest"
	chest_interactable.is_interactable = true

func _on_chest_interact() -> void:
	if chest_opened:
		return
		
		
	chest_opened = true
	chest_interactable.is_interactable = false
	chest_interactable.interact_name = "Chest (Opened)"

# Optional visual swap
	chest_sprite.texture = load("res://asset/map/chest/chest_open.png")

# Unlock the exit door now
	if exit_door.has_method("unlock"):
		exit_door.unlock()
