extends Node2D

var speed := 1.8
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(%TileMapLayerFG, "global_position:y", 60, speed)
	tween.tween_property(%TileMapLayerFG, "global_position:y", -48, speed)
