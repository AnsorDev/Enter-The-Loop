extends ExitHole

var speed := 100.0

var _player_entered_count := 0
var _new_position: Vector2
var _is_animation_playing := false

func _ready() -> void:
	body_entered.connect(func(body: Node2D) -> void:
		if body is Player:
			_player_entered_count += 1
			_new_position = Vector2(randi_range(0, 192), randi_range(16, 128))
	)

func _physics_process(delta: float) -> void:
	match _player_entered_count:
		1:
			global_position = global_position.move_toward(_new_position, speed * delta)		
		2:
			global_position = global_position.move_toward(_new_position, speed * delta)		
		3:
			global_position = global_position.move_toward(_new_position, speed * delta)		
		4:
			global_position = global_position.move_toward(_new_position, speed * delta)		
		5:
			global_position = global_position.move_toward(_new_position, speed * delta)		
		6:
			if _is_animation_playing == false:
				_is_animation_playing = true
				play_animation(%Player)
