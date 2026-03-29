extends StaticBody2D

@onready var interactable: Area2D = $interactable
@onready var digicode: Sprite2D = $Digicode

func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
	if digicode.frame == 0:
		digicode.modulate = Color(0.5, 0.5, 0.5)
		interactable.is_interactable = false
		
		
		
		
		
		print("the player gained 10 gold")
