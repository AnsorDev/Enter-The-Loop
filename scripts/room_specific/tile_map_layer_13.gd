extends AnimatableBody2D

@export var speed: float

func _physics_process(delta: float) -> void:
	rotate(1.0 * speed * delta)
