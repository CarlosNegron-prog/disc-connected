extends StaticBody2D

# Which player's map this button is on (1 or 2)
@export var player_id: int = 1
# "red" or "blue"
@export var button_color: String = "red"
# "digicode" uses texture swap; "switch_anim" animates through 3 frames
@export var button_type: String = "digicode"

var is_pressed := false

@onready var interactable: Area2D = $interactable

func _ready() -> void:
	interactable.interact = _on_interact
	interactable.interact_name = "Press " + button_color.to_upper() + " button"

func _on_interact() -> void:
	if is_pressed:
		return
	is_pressed = true
	interactable.is_interactable = false
	_update_visuals()
	_notify_puzzle()

func _update_visuals() -> void:
	if button_type == "digicode":
		var sprite: Sprite2D = $Digicode
		sprite.texture = load("res://map2/objects/digicode_disabled.png")
	elif button_type == "switch_anim":
		_animate_switch()

func _animate_switch() -> void:
	var sprite: Sprite2D = $SwitchSprite
	sprite.texture = load("res://map/switch2/switch1.png")
	await get_tree().create_timer(0.2).timeout
	sprite.texture = load("res://map/switch2/switch2.png")

func reset_button() -> void:
	is_pressed = false
	interactable.is_interactable = true
	if button_type == "digicode":
		$Digicode.texture = load("res://map2/objects/digicode.png")
	elif button_type == "switch_anim":
		$SwitchSprite.texture = load("res://map/switch2/switch0.png")

func _notify_puzzle() -> void:
	var group_name = "level_puzzle_" + str(player_id)
	var puzzles = get_tree().get_nodes_in_group(group_name)
	if puzzles.size() > 0:
		puzzles[0].register_button_press(button_color, self)
