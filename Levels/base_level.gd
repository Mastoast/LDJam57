extends Node2D

@export var pitch:float = 1.0

func _ready() -> void:
	MusicPlayer.play(MusicPlayer.music_80bpm, pitch)
