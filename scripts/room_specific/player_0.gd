extends Player

# Player State during the Room0 Scene
func _ready() -> void:
	super()
	room_0_state()
	speed = 50

func _process(delta):
	zoom_in_camera()

func _physics_process(delta: float) -> void:
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
			_footstep_cooldown = 0.55
		_footstep_cooldown -= delta
	else:
		velocity = lerp(velocity, Vector2.ZERO, 20 * delta)
		
		%AnimatedSprite2D.play("idle")
		if %AnimationPlayer.is_playing() == true:
			%AnimationPlayer.play("RESET")
		%GPUParticles2D.emitting = false
		%AudioStreamPlayerWalk.stop()
	
	move_and_slide()
	
# Normal Audio and not Reverb, also changes Particle color to dirt like
func room_0_state() -> void:
	%AudioStreamPlayerWalk.bus = "Master"
	%AudioStreamPlayerJump.bus = "Master"
	%AudioStreamPlayerFall.bus = "Master"
	var tween := create_tween().tween_property(%AudioStreamPlayerWalk, "volume_db", -30, 2.0).from(-55)
	
	%AnimatedSprite2D.speed_scale = 0.7
	%AnimationPlayer.speed_scale = 0.8
	%GPUParticles2D.modulate = Color8(111, 102, 33, 200)
	%GPUParticles2D.amount = 5
	%GPUParticles2D.lifetime = 0.5
	%GPUParticles2D.explosiveness = 0.6

func zoom_in_camera() -> void:
	var min_zoom := Vector2(4.0, 4.0)  # Zoomed in
	var max_zoom := Vector2(9.0, 9.0)  # Normal
	var min_distance := 30.0
	var max_distance := 450.0
	
	#clamp[ value={ inverse_lerp(from, to, weight) }, min, max ]
	#1.0 return = zoomed in max, 0.0 = zoomed out max
	var distance_to_hole := global_position.distance_to(%ExitHole.global_position)
	var zoom_amount: float = clamp(inverse_lerp(min_distance, max_distance, distance_to_hole), 0.0, 1.0)
	%Camera2D.zoom = lerp(max_zoom, min_zoom, zoom_amount) 
