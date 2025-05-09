extends Node2D

signal move_ship
signal emit_little_sonar
signal emit_big_sonar

@export var player_dash: float = 10
@export var player_big_dash: float = 20

@export var music_index:int = 1

func _ready() -> void:
	MusicPlayer.new_beat.connect(on_beat)

func on_beat(beat_count:int):
	if music_index == 2:
		on_beat_lvl2(beat_count)
	else:
		on_beat_lvl1(beat_count)

func on_beat_lvl1(beat_count:int):
	if beat_count % 4 == 0:
		move_ship.emit(player_big_dash, MusicPlayer.beat_length)
		emit_big_sonar.emit(MusicPlayer.beat_length)
	elif beat_count % 4 == 1:
		emit_little_sonar.emit(MusicPlayer.beat_length)
	else:
		move_ship.emit(player_dash, MusicPlayer.beat_length)

func on_beat_lvl2(beat_count:int):
	if beat_count % 4 == 1:
		emit_little_sonar.emit(MusicPlayer.beat_length)
	elif beat_count % 4 == 2:
		emit_big_sonar.emit(MusicPlayer.beat_length)
	else:
		move_ship.emit(player_big_dash, MusicPlayer.beat_length)
