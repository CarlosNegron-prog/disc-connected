extends CharacterBody2D

@export var speed = 110.0
@export var friction = 0.2
@export var acceleration = 0.1

func _physics_process(_delta):
	# 1. Get input direction (WASD or Arrow keys by default)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. Apply movement
	if direction != Vector2.ZERO:
		# Gradually move toward the target velocity
		velocity = velocity.lerp(direction * speed, acceleration)
	else:
		# Gradually slow down to a stop
		velocity = velocity.lerp(Vector2.ZERO, friction)

	# 3. Handle collisions and movement
	move_and_slide()
