extends Area2D

@export_multiline var info_text: String
@export var duration: int
@export var fate_out_duration: int

var tween: Tween
var tween2: Tween
func _ready() -> void:
	%RichTextLabel.text = ""
	area_entered.connect(func(_area: Area2D) -> void:
		%RichTextLabel.visible = true
		%AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.1)
		%AudioStreamPlayer2D.play()
		if tween2 != null:
			tween2.kill()
		%RichTextLabel.modulate.a = 1.0
		animate_text_characters()
		%RichTextLabel.text = info_text
	)
	
	area_exited.connect(func(_area: Area2D) -> void:
		#%RichTextLabel.visible = false
		tween2 = create_tween()
		tween2.tween_property(%RichTextLabel, "modulate:a", 0.0, fate_out_duration)
	)

func animate_text_characters() -> void:
	%RichTextLabel.visible_ratio = 0.0
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(%RichTextLabel, "visible_ratio", 1.0, duration)
	
