extends Area2D

# This looks for a Timer node that is a CHILD of this Hitbox
@onready var timer: Timer = $Timer2 
const GAME_OVER_SCENE = "res://scenes/GameOver.tscn"

func _on_body_entered(body: Node2D) -> void:
	# 1. Check if the thing that touched us is in the "player" group
	if body.is_in_group("player"):
		print("Player hit! Waiting 1 second...")
		
		# 1. Freeze the player
		body.set_physics_process(false)
		if body.has_node("AnimatedSprite2D"):
			body.get_node("AnimatedSprite2D").stop()
		
		# 2. CREATE THE DELAY (No Timer node needed!)
		# This creates a 1.0 second timer and waits for it to finish
		await get_tree().create_timer(0.4).timeout
		
		# 3. CHANGE SCENE
		print("Changing to Game Over Scene")
		var error = get_tree().change_scene_to_file(GAME_OVER_SCENE)
		
		if error != OK:
			print("ERROR: Scene change failed: ", error)

func _on_timer_timeout() -> void:
	print("Timer Finished Starting Gameover")
	get_tree().change_scene_to_file(GAME_OVER_SCENE)


func _on_timer_2_timeout() -> void:
	pass # Replace with function body.
