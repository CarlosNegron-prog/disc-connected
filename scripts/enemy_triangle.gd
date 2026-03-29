extends CharacterBody2D

@export var speed = 150.0
@export var acceleration = 0.05

var player = null

func _ready():
	# Find the player in the scene tree
	# Make sure your Player node is added to a group named "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(_delta):
	if player:
		# 1. Calculate the direction toward the player
		var direction = (player.global_position - global_position).normalized()
		
		# 2. Move toward the player slowly
		velocity = velocity.lerp(direction * speed, acceleration)
		
		# 3. Apply movement and handle collisions
		move_and_slide()
