extends CharacterBody2D

@export var speed = 110.0
@export var friction = 0.2
@export var acceleration = 0.1

func _ready() -> void:
	$InteractingComponent.interact_action = "player2_interact"

func _physics_process(_delta):
	# Get input direction using Player 2 custom actions (Arrow keys only)
	var direction = Input.get_vector("player2_left", "player2_right", "player2_up", "player2_down")

	if direction != Vector2.ZERO:
		velocity = velocity.lerp(direction * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

	move_and_slide()
