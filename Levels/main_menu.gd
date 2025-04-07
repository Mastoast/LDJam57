extends Node2D

var game_level_path = "res://Levels/base_level.tscn"
var fade_delay = 2.0

func _ready() -> void:
	$AnimationPlayer.play("submarine_float")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CIRC)
		tween.tween_property(self, "modulate", Color(0,0,0,1), fade_delay)
		tween.tween_callback(load_level)

func load_level():
	get_tree().change_scene_to_file(game_level_path)
