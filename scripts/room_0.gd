extends Node2D

func _ready() -> void:	
	%CanvasModulate.visible = true
	get_tree().paused = true
	
	%Button.pressed.connect(func() -> void:
		%Button.disabled = true
		%AnimationPlayerStartGame.play("brighter")
		await get_tree().create_timer(1.0).timeout
		get_tree().paused = false
		
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	)
	
	GameManager.player_in_hole.connect(func() -> void:
		%AnimationPlayerHole.stop()
	)
	
	
