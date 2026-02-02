class_name Player extends CharacterBody2D

@export var speed = 70.0

@onready var hurt_box: Area2D = %HurtBox
@onready var protect_box: Area2D = %ProtectBox
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D


var _footstep_cooldown := 0.0
var _protect_box_overlap_count := 0

# Debug
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameManager.debug()
	if event.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()

func _ready() -> void:
	# reset particale color
	#%GPUParticles2D.modulate = Color8(255, 255, 255, 255)

	hurt_box.body_entered.connect(func(_body: Node2D) -> void:
		%AudioStreamPlayerFall.pitch_scale = randf_range(0.95, 1.1)
		%AudioStreamPlayerFall.play()
		
		hurt_box.set_deferred("monitoring", false)
		protect_box.set_deferred("monitoring", false)
		# change z index so in case falling while a moving platform infront
		#z_index = 4
		await get_tree().create_timer(0.04).timeout
		set_physics_process(false)
		%AnimatedSprite2D.play("falling")
		%GPUParticles2D.emitting = false
		
		
		# Falling Animation
		var tween_1 := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween_1.tween_property(self, "global_position:y", global_position.y + 6, .5)
		tween_1.parallel().tween_property(self, "global_rotation_degrees", randf_range(-88, 88), 0.5)
		tween_1.parallel().tween_property(self, "scale", Vector2(0, 0), .6).set_delay(.2)
		tween_1.parallel().tween_property(self, "modulate", Color8(28, 28, 28), .6).set_delay(.4)

		await %AudioStreamPlayerFall.finished
		GameManager.restart_game()
	)
	
	# This logic works bc in godot body_entered signal is emitted before body_exited
	protect_box.body_entered.connect(func(_body: Node2D) -> void:
		_protect_box_overlap_count += 1
		hurt_box.monitoring = false
	)
	protect_box.body_exited.connect(func(_body: Node2D) -> void:
		_protect_box_overlap_count = max(_protect_box_overlap_count - 1, 0)
		if _protect_box_overlap_count == 0:
			hurt_box.monitoring = true
	)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction:
		if direction.x != 0:
			%AnimatedSprite2D.flip_h = direction.x < 0
		velocity = velocity.move_toward(direction * speed, speed * 6.0 * delta)
		
		%GPUParticles2D.emitting = true
		%AnimatedSprite2D.play("run")
		
		if %AnimationPlayer.is_playing() == false:
			%AnimationPlayer.play("run")
			
		if %AudioStreamPlayerWalk.playing != true and _footstep_cooldown <= 0:
			%AudioStreamPlayerWalk.play()
			_footstep_cooldown = 0.4
		_footstep_cooldown -= delta
	else:
		velocity = lerp(velocity, Vector2.ZERO, 5 * delta)
		
		%AnimatedSprite2D.play("idle")
		if %AnimationPlayer.is_playing() == true:
			%AnimationPlayer.play("RESET")
		%GPUParticles2D.emitting = false
		%AudioStreamPlayerWalk.stop()
	
	move_and_slide()

# not an actual jump, but an animation
func jump() -> void:
	%AudioStreamPlayerJump.pitch_scale = randf_range(0.95, 1.10)
	#%AudioStreamPlayerJump.volume_db = randf_range(0.95, 1.10)
	%AudioStreamPlayerJump.play()
	%AnimatedSprite2D.play("jump")
