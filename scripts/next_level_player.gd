extends CharacterBody2D

@export var speed = 110.0
@export var friction = 0.2
@export var acceleration = 0.1

# X-axis: W (left) and D (right) — controlled by one player
# Y-axis: Up arrow (up) and Down arrow (down) — controlled by the other player

func _physics_process(_delta: float) -> void:
	var dir_x := 0.0
	var dir_y := 0.0

	# X movement via W / D
	if Input.is_action_pressed("player1_left"):
		dir_x -= 1.0
	if Input.is_action_pressed("player1_right"):
		dir_x += 1.0

	# Y movement via Up / Down arrows
	if Input.is_action_pressed("player2_up"):
		dir_y -= 1.0
	if Input.is_action_pressed("player2_down"):
		dir_y += 1.0

	var direction = Vector2(dir_x, dir_y).normalized()

	if direction != Vector2.ZERO:
		velocity = velocity.lerp(direction * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

	move_and_slide()
