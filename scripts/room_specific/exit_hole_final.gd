extends ExitHole 

func _ready() -> void:
	body_entered.connect(func(body: Node2D) -> void:
		if body is Player:
			play_animation(body)
	)	

func play_animation(body: Player) -> void:
	body.set_physics_process(false)
	set_deferred("monitoring", false)
	GameManager.player_in_hole.emit()
	
	scale = Vector2(1.3, 1.3)
	body.scale = Vector2(1.1, 1.1)
	body.gpu_particles_2d.emitting = false
	body.jump()
	body.hurt_box.set_deferred("monitoring", false)
	
	var tween_1 := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween_1.tween_property(body, "global_position:x", global_position.x, .5)
	tween_1.parallel().tween_property(body, "global_rotation_degrees", randf_range(-88, 88), 0.5)
	tween_1.parallel().tween_property(body, "scale", Vector2(0, 0), .6).set_delay(.4)
	tween_1.parallel().tween_property(body, "modulate", Color8(28, 28, 28), .6).set_delay(.4)
	tween_1.parallel().tween_property(self, "scale", Vector2.ZERO, 0.5).set_delay(.7)
	tween_1.parallel().tween_property(%PointLight2D, "color:a", 0.0, 0.5).set_delay(.7)
	tween_1.parallel().tween_property(%RichTextLabel, "visible_ratio", 1.0, 5.0).set_delay(.7)
	
	tween_1.tween_property(%CanvasModulate, "color", Color8(0, 0, 0), 10.0).set_trans(Tween.TRANS_LINEAR)
	
	var tween_2 := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#used ternary expression, otherwise jump feels too weak from below and too strong from up
	tween_2.tween_property(
		body, "global_position:y", \
		global_position.y - 25.0 if body.global_position.y < global_position.y \
		else body.global_position.y - 30.0, 0.25)
	tween_2.tween_property(body, "global_position:y", global_position.y, 0.25)
	
	# Loads next level
	await tween_1.finished
	GameManager.call_deferred("load_next_level")
