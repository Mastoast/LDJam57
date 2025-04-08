extends Node2D

@export var pitch:float = 1.0
@export var fade_delay = 2.0
@export var intro_enabled = true

var main_menu_path = "res://Levels/Menu.tscn"

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

func _process(_delta) -> void:
	$Control.position = $Player.position

func start_level():
	MusicPlayer.play(MusicPlayer.music_80bpm, pitch)

func start_level2():
	MusicPlayer.play(MusicPlayer.music_glitchy, pitch)

func load_main_menu():
	get_tree().change_scene_to_file(main_menu_path)

func _on_first_sonar_activation(body: Node2D):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("base_level/unlock_sonar")
		$"Dialogue boxes/Dialogue 2 trigger".collision_mask = 0

func _on_dialogue_3(body: Node2D):
	if body.is_in_group("Player"):
		$DialogueAudioStreamPlayer.stream = dialogue3
		$DialogueAudioStreamPlayer.play()
		$"Dialogue boxes/Dialogue 3 trigger".collision_mask = 0

func _on_dialogue_4(body: Node2D):
	if body.is_in_group("Player"):
		$DialogueAudioStreamPlayer.stream = dialogue4
		$DialogueAudioStreamPlayer.play()
		$"Dialogue boxes/Dialogue 4 trigger".collision_mask = 0

func _on_second_sonar_activation(body: Node2D):
	if body.is_in_group("Player"):
		MusicPlayer.stop()
		$AnimationPlayer.play("base_level/unlock_organic_sonar")
		$"Dialogue boxes/Dialogue 5 trigger".collision_mask = 0
		$MusicListener.music_index = 2

func _on_dialogue_6(body: Node2D):
	if body.is_in_group("Player"):
		$DialogueAudioStreamPlayer.stream = dialogue6
		$DialogueAudioStreamPlayer.play()
		$"Dialogue boxes/Dialogue 6 trigger".collision_mask = 0

func _on_end_cutscene_trigger(body: Node2D):
	if body.is_in_group("Player"):
		Save.is_ending = true
		MusicPlayer.stop()
		$AnimationPlayer.play("base_level/final_cutscene")
		$"Dialogue boxes/Dialogue 7 trigger".collision_mask = 0

func _write_text(text, label_name):
	var get_label = get_node("control/"+label_name)
	get_label.text = Text.texts[text]
