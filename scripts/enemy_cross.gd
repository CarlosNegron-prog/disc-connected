extends CharacterBody2D

@export var speed = 60.0         # Slower base speed than the Triangle
@export var acceleration = 0.05
@export var dash_power = 200.0   # The strength of the burst
@export var dash_interval = 2.0  # How often it dashes (seconds)

var player = null
var player_in_range = false
var is_dashing = false

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(_delta):
	if player and player_in_range:
		var direction = (player.global_position - global_position).normalized()
		
		# If not dashing, just move slowly toward player
		if not is_dashing:
			velocity = velocity.lerp(direction * speed, acceleration)
		
		move_and_slide()
	else:
		# Slow down to a stop when out of range
		velocity = velocity.lerp(Vector2.ZERO, acceleration)
		move_and_slide()

# This function handles the "Dash" rhythm
func start_dash_loop():
	while player_in_range:
		# 1. Wait for the interval
		await get_tree().create_timer(dash_interval).timeout
		
		# 2. Check again if player is still there before dashing
		if player_in_range and player:
			perform_dash()

func perform_dash():
	is_dashing = true
	var dash_direction = (player.global_position - global_position).normalized()
	
	# Sudden burst of speed
	velocity = dash_direction * dash_power
	
	# Wait a tiny bit for the burst to feel impactful
	await get_tree().create_timer(0.2).timeout
	is_dashing = false

# --- Signals ---

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		start_dash_loop() # Start the "heartbeat" of the dashes

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		is_dashing = false
