class_name GeneralRoomLayout extends Node2D


func _ready() -> void:
	%CanvasModulate.visible = true
	%VignetteShader.visible = true
	
	%Player.set_physics_process(false)
	# if not set to false, may fall down in case of a near fallpit
	%Player.hurt_box.monitoring = false
	
	if GameManager._current_level_index > 0 or GameManager._is_game_restarted == true:
		if GameManager._is_game_restarted == false:
			%Label.text = str(GameManager._current_level_index)
		else: 
			%Label.text = str(GameManager._current_level_index + 1)
			print(GameManager._current_level_index + 1)
	
	%AnimationPlayerMain.animation_finished.connect(func(_anim_name: StringName) -> void:
		%Player.set_physics_process(true)
		%Player.hurt_box.monitoring = true
	)
