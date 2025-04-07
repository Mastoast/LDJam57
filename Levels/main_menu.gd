extends Node2D

var game_level_path = "res://Levels/base_level.tscn"
var fade_delay = 2.0

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1,1,1,0), fade_delay)
		tween.tween_callback(load_level)

func load_level():
	get_tree().change_scene_to_file(game_level_path)
