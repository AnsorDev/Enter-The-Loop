extends Node2D


var speed := 0.5

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	var tween := create_tween().set_loops()
	tween.tween_property(%TileMapLayerFG, "global_position:y", 15.945, speed)
	tween.tween_property(%TileMapLayerFG, "global_position:y", 0, speed)
