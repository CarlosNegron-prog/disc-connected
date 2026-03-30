extends StaticBody2D

# Which player's map this door belongs to (1 or 2)
@export var player_id: int = 1
var door_used := false
var is_unlocked := false


@onready var interactable: Area2D = $interactable
@onready var door_sprite: Sprite2D = $DoorSprite

func _ready() -> void:
	add_to_group("exit_door_" + str(player_id))
	interactable.interact = _on_interact
	interactable.interact_name = "Door (Locked)"
	interactable.is_interactable = false

func unlock() -> void:
	is_unlocked = true
	interactable.is_interactable = true
	interactable.interact_name = "Exit — interact to leave!"
	# Tint door green to show it is open
	door_sprite.modulate = Color(0.2, 1.0, 0.2)

func _on_interact() -> void:
	if not is_unlocked:
		return
	var managers = get_tree().get_nodes_in_group("game_manager")
	if managers.size() > 0:
		managers[0].on_door_interacted(player_id)
		
func on_door_interacted(_p_id: int) -> void:
	if door_used:
		return
	door_used = true
	get_tree().change_scene_to_file("res://scenes/YouWin.tscn")
