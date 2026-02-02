extends ExitHole


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(func(body: Node2D) -> void:
		if body is Player:
			%TextureRect.visible = true
			await get_tree().create_timer(.07).timeout
			%TextureRect.visible = false
			play_animation(body)
	)	
