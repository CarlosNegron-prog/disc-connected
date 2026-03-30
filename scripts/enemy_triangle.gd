extends CharacterBody2D

@export var speed = 120.0
@export var acceleration = 0.05
@export var detection_range = 200.0

var player = null
var player_in_range = false  # ← new flag

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(_delta):
	# Only chase if player is within detection range
	if player and player_in_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.lerp(direction * speed, acceleration)
		move_and_slide()
	else:
		# Slow down when player is out of range
		velocity = velocity.lerp(Vector2.ZERO, acceleration)
		move_and_slide()

# Called by DetectionZone signals
func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
