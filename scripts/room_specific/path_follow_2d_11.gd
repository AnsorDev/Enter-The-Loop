extends PathFollow2D

func _ready() -> void:
	GameManager.player_in_hole.connect(func() -> void:
		call_deferred("set_process", false)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += 0.3 * delta
	
