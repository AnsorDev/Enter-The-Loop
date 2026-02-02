extends Node

var levels: Array[PackedScene] = [
	preload("res://scenes/rooms(inherited)/room_2.tscn"),
	preload("res://scenes/rooms(inherited)/room_2_1.tscn"),
	preload("res://scenes/rooms(inherited)/room_3.tscn"),
	preload("res://scenes/rooms(inherited)/room_4.tscn"),
	preload("res://scenes/rooms(inherited)/room_4_1.tscn"),
	preload("res://scenes/rooms(inherited)/room_5.tscn"),
	preload("res://scenes/rooms(inherited)/room_6.tscn"),
	preload("res://scenes/rooms(inherited)/room_7.tscn"),
	preload("res://scenes/rooms(inherited)/room_8.tscn"),
	preload("res://scenes/rooms(inherited)/room_9.tscn"),
	preload("res://scenes/rooms(inherited)/room_10.tscn"),
	preload("res://scenes/rooms(inherited)/room_11.tscn"),
	preload("res://scenes/rooms(inherited)/room_12.tscn"),
	preload("res://scenes/rooms(inherited)/room_13.tscn"),
	preload("res://scenes/rooms(inherited)/room_14.tscn"),
]

var _current_level_index := 0
var _audio_stream_player: AudioStreamPlayer
var _start_music := true
var _load_room_1 := true
var _is_game_restarted := false

var _level_to_erase: Resource

signal player_in_hole

func load_next_level() -> void:
	# Very first (introduction) level after player jumps in the hole
	if _load_room_1 == true:
		_load_room_1 = false
		get_tree().call_deferred("change_scene_to_packed", preload("res://scenes/rooms(inherited)/room_1.tscn"))
		levels.shuffle()
	# every other level afterwards
	else:
		# starts music 
		if _start_music == true:
			restart_music()
			_start_music = false
			
		_current_level_index += 1
		print("level_index: " ,_current_level_index)
		print(levels.size())
		if _current_level_index <= levels.size():
			get_tree().call_deferred("change_scene_to_packed", levels[_current_level_index-1])
		elif _current_level_index == levels.size() + 1:
			_audio_stream_player.stream = preload("res://sounds/mixkit-european-forest-ambience-1213.wav")
			_audio_stream_player.autoplay = true
			_audio_stream_player.bus = "Hole"
			_audio_stream_player.volume_db = -60.0
			_audio_stream_player.play(randf_range(0.0, 30.0))

			var rand_volume_db := randf_range(-18.0, -20.0)
			var tween := create_tween()
			tween.tween_property(_audio_stream_player, "volume_db", rand_volume_db, 2.0)
			get_tree().call_deferred("change_scene_to_packed", preload("res://scenes/final_room_1.tscn"))

			
func restart_game() -> void:
	print("level size before death: ", levels.size())
	if _level_to_erase != load(get_tree().current_scene.scene_file_path) and _level_to_erase != null:
		levels.append(_level_to_erase)
	_level_to_erase = load(get_tree().current_scene.scene_file_path)
	levels.erase(_level_to_erase)
	print("level size after death: ", levels.size())
	_current_level_index = 0
	restart_music()
	levels.shuffle()
	_is_game_restarted = true
	print(_is_game_restarted)
	get_tree().reload_current_scene()

func restart_music() -> void:
	if _audio_stream_player == null:
		_audio_stream_player = AudioStreamPlayer.new()
		add_child(_audio_stream_player)
		_audio_stream_player.stream = preload("res://sounds/Music/music_jewels.ogg")
		_audio_stream_player.autoplay = true
	_audio_stream_player.volume_db = -60.0
	_audio_stream_player.play(randf_range(0.0, 30.0))

	var rand_volume_db := randf_range(-28.0, -30.0)
	var tween := create_tween()
	tween.tween_property(_audio_stream_player, "volume_db", rand_volume_db, 2.0)

func debug():
	print("current scene: ", get_tree().current_scene.scene_file_path)
	print("levels -> size ", levels.size(), ":")
	for i in levels.size():
		print("   ", levels[i].resource_path.get_basename())
	print("")
