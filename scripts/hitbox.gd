extends Area2D

# This looks for a Timer node that is a CHILD of this Hitbox
@onready var timer: Timer = $Timer2 

func _on_body_entered(body: Node2D) -> void:
	# 1. Check if the thing that touched us is in the "player" group
	if body.is_in_group("player"):
		print("Loser")
		
		# 2. Freeze the player so they can't run away
		body.set_physics_process(false)
		
		# 3. Start the restart timer
		if timer:
			timer.start()
		else:
			# Fallback if you haven't added the Timer node yet
			get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_timer_2_timeout() -> void:
	pass # Replace with function body.
