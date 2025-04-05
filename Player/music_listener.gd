extends Node2D

signal move_ship
signal emit_little_sonar
signal emit_big_sonar

@export var player_dash: float = 10
@export var player_big_dash: float = 20

func _ready() -> void:
	MusicPlayer.new_beat.connect(on_beat)

func on_beat(beat_count:int):
	if beat_count % 4 == 0:
		move_ship.emit(player_big_dash)
		emit_little_sonar.emit()
	else:
		move_ship.emit(player_dash)
