extends Node2D

@export var pitch:float = 1.0
@export var fade_delay = 2.0
@export var intro_enabled = true

var dialogue1 = load("res://Assets/audio/Dialogues/Dialogue 1.wav")
var dialogue2 = load("res://Assets/audio/Dialogues/Dialogue 2.wav")
var dialogue3 = load("res://Assets/audio/Dialogues/Dialogue 3.wav")
var dialogue4 = load("res://Assets/audio/Dialogues/Dialogue 4.wav")
var dialogue5a = load("res://Assets/audio/Dialogues/Dialogue 5a.wav")
var dialogue5b = load("res://Assets/audio/Dialogues/Dialogue 5b.wav")
var dialogue6 = load("res://Assets/audio/Dialogues/Dialogue 6.wav")
var dialogue7a = load("res://Assets/audio/Dialogues/Dialogue 7a.wav")
var dialogue7b = load("res://Assets/audio/Dialogues/Dialogue 7b.wav")
var dialogue7c = load("res://Assets/audio/Dialogues/Dialogue 7c.wav")

func _ready() -> void:
	if intro_enabled :
		$AnimationPlayer.play("base_level/intro")
	else:
		start_level()

func start_level():
	MusicPlayer.play(MusicPlayer.music_80bpm, pitch)
