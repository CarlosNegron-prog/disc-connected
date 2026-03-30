extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("Loser") 
	timer.start()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_detection_zone_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_detection_zone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
