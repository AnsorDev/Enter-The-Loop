extends ExitHole

func _ready() -> void:
	super()
	global_position.x = randi_range(56, 192)
	global_position.y = randi_range(16, 128)
	
