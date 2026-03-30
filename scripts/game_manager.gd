extends Node2D

# How many seconds the second player has to respond
const SYNC_TIMEOUT := 5.0

# Tracks a pending (un-synced) button press: color -> {player_id, button_node}
var pending: Dictionary = {}

# Which colors have been successfully synchronized
var synced: Dictionary = {"red": false, "blue": false}

# Which players have interacted with their exit door
var door_done: Dictionary = {1: false, 2: false}

@onready var countdown_label_red: Label = $UI/CountdownLabelRed
@onready var countdown_label_blue: Label = $UI/CountdownLabelBlue
@onready var puzzle_complete_label: Label = $UI/PuzzleCompleteLabel
@onready var timer_red: Timer = $UI/TimerRed
@onready var timer_blue: Timer = $UI/TimerBlue
@onready var countdown_sound: AudioStreamPlayer = $UI/CountdownSound

func _ready() -> void:
	add_to_group("game_manager")
	countdown_label_red.visible = false
	countdown_label_blue.visible = false
	puzzle_complete_label.visible = false

	# Connect after one frame so all SubViewport children are ready
	await get_tree().process_frame
	_connect_puzzle_signals()

func _connect_puzzle_signals() -> void:
	var puzzle1 = get_node_or_null("LeftContainer/LeftViewport/LevelPuzzle1")
	var puzzle2 = get_node_or_null("RightContainer/RightViewport/LevelPuzzle2")
	if puzzle1:
		puzzle1.button_activated.connect(_on_button_activated)
	if puzzle2:
		puzzle2.button_activated.connect(_on_button_activated)

# Called when any player presses a button
func _on_button_activated(p_id: int, color: String, button_node: Node) -> void:
	if synced.get(color, false):
		# Already synced — ignore duplicate presses
		return

	if pending.has(color):
		var pen: Dictionary = pending[color]
		if pen["player_id"] != p_id:
			# The other player responded in time — sync this color!
			_sync_color(color, pen["button_node"], button_node)
		# Same player pressed again while timer was running — ignore
	else:
		# First press for this color — start countdown
		pending[color] = {"player_id": p_id, "button_node": button_node}
		_start_timer(color, p_id)

func _sync_color(color: String, _btn1: Node, _btn2: Node) -> void:
	synced[color] = true
	pending.erase(color)
	_stop_timer(color)
	_hide_countdown(color)

	if synced["red"] and synced["blue"]:
		_unlock_all_doors()

func _start_timer(color: String, initiator_id: int) -> void:
	var other_id = 3 - initiator_id  # 1↔2
	var label_text = "P%d: press %s in 5s!" % [other_id, color.to_upper()]
	if color == "red":
		countdown_label_red.text = label_text
		countdown_label_red.visible = true
		timer_red.start(SYNC_TIMEOUT)
	else:
		countdown_label_blue.text = label_text
		countdown_label_blue.visible = true
		timer_blue.start(SYNC_TIMEOUT)
	countdown_sound.play()

func _stop_timer(color: String) -> void:
	if color == "red":
		timer_red.stop()
	else:
		timer_blue.stop()
	# Stop sound only if both timers are no longer running
	if timer_red.is_stopped() and timer_blue.is_stopped():
		countdown_sound.stop()

func _hide_countdown(color: String) -> void:
	if color == "red":
		countdown_label_red.visible = false
	else:
		countdown_label_blue.visible = false

func _process(_delta: float) -> void:
	if not timer_red.is_stopped():
		var pen = pending.get("red", {})
		var other = 3 - pen.get("player_id", 1)
		countdown_label_red.text = "P%d: press RED in %ds!" % [other, int(ceil(timer_red.time_left))]
	if not timer_blue.is_stopped():
		var pen = pending.get("blue", {})
		var other = 3 - pen.get("player_id", 1)
		countdown_label_blue.text = "P%d: press BLUE in %ds!" % [other, int(ceil(timer_blue.time_left))]

func _on_red_timer_timeout() -> void:
	if pending.has("red"):
		pending["red"]["button_node"].reset_button()
		pending.erase("red")
	countdown_label_red.visible = false
	if timer_blue.is_stopped():
		countdown_sound.stop()

func _on_blue_timer_timeout() -> void:
	if pending.has("blue"):
		pending["blue"]["button_node"].reset_button()
		pending.erase("blue")
	countdown_label_blue.visible = false
	if timer_red.is_stopped():
		countdown_sound.stop()

func _unlock_all_doors() -> void:
	puzzle_complete_label.text = "Puzzle solved! Find the exit door!"
	puzzle_complete_label.visible = true
	for i in [1, 2]:
		var doors = get_tree().get_nodes_in_group("exit_door_" + str(i))
		for door in doors:
			door.unlock()

# Called by exit_door.gd when a player interacts with their door
func on_door_interacted(p_id: int) -> void:
	door_done[p_id] = true
	if door_done[1] and door_done[2]:
		_transition_to_next_level()

func _transition_to_next_level() -> void:
	get_tree().change_scene_to_file("res://scenes/next_level.tscn")
