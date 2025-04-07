extends Node2D

@export var pitch:float = 1.0
@export var fade_delay = 2.0

func _ready() -> void:
	modulate = Color(0,0,0,1)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "modulate", Color(1,1,1,1), fade_delay)
	tween.tween_callback(start_level)

func start_level():
	MusicPlayer.play(MusicPlayer.music_80bpm, pitch)
