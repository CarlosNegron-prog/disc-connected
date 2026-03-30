extends Node

# Which player's map this puzzle belongs to (1 or 2)
@export var player_id: int = 1

# Emitted when a button is pressed, passing player_id, color, and the button node
signal button_activated(p_id: int, color: String, button_node: Node)

func _ready() -> void:
	add_to_group("level_puzzle_" + str(player_id))

# Called by switch.gd when a button is pressed
func register_button_press(color: String, button_node: Node) -> void:
	button_activated.emit(player_id, color, button_node)

# Called by game_manager when the whole puzzle is solved
func complete_puzzle() -> void:
	var doors = get_tree().get_nodes_in_group("exit_door_" + str(player_id))
	for door in doors:
		door.unlock()
