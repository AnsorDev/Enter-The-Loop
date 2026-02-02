extends TileMapLayer

@export var speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(%TileMapLayerDeath, "global_position:x", 144, speed).set_delay(2.0)
