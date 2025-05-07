extends Node2D

@export var pitch_level1:float = 1.0
@export var pitch_level2:float = 1.0
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
	MusicPlayer.play(MusicPlayer.music_80bpm, pitch_level1)

func start_level2():
	MusicPlayer.play(MusicPlayer.music_glitchy, pitch_level2)

func load_main_menu():
	get_tree().change_scene_to_file(main_menu_path)

func _on_first_sonar_activation(body: Node2D):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("base_level/unlock_sonar")
		$"Dialogue boxes/Dialogue 2 trigger".collision_mask = 0

func _on_dialogue_3(body: Node2D):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("base_level/dialogue_wreck")
		$"Dialogue boxes/Dialogue 3 trigger".collision_mask = 0

func _on_dialogue_4(body: Node2D):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("base_level/wimp_dialogue")
		$"Dialogue boxes/Dialogue 4 trigger".collision_mask = 0

func _on_second_sonar_activation(body: Node2D):
	if body.is_in_group("Player"):
		MusicPlayer.stop()
		$AnimationPlayer.play("base_level/unlock_organic_sonar")
		$"Dialogue boxes/Dialogue 5 trigger".collision_mask = 0
		$MusicListener.music_index = 2

func _on_dialogue_6(body: Node2D):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("base_level/are_you_sure_dialogue")
		$"Dialogue boxes/Dialogue 6 trigger".collision_mask = 0

func _on_end_cutscene_trigger(body: Node2D):
	if body.is_in_group("Player"):
		Save.is_ending = true
		MusicPlayer.stop()
		$AnimationPlayer.play("base_level/final_cutscene")
		$"Dialogue boxes/Dialogue 7 trigger".collision_mask = 0

func _write_text(text:String, label_name:String):
	var get_label = get_node("Control/"+label_name)
	get_label.text = Text.texts[text]

func clear_label_text():
	$Control/LabelCharacter1.text = ""
	$Control/LabelCharacter2.text = ""
