extends Node2D

# Get the reference to the material to pass data to shader parameters.
@onready var SHADER: ShaderMaterial = self.material
@export var organic = false

var player : _Player
var maxD : float

func _ready():
	player = get_tree().root.get_node("BaseLevel/Player")
	if organic:
		player.sendSonarTwoWithTime.connect(_processSonarTime)
	else:
		player.sendSonarWithTime.connect(_processSonarTime)
	player.setSonarPulseTime.connect(_setSonarPulseTime)
	maxD = SHADER.get_shader_parameter("max_distance")

func _process(_delta):
	SHADER.set_shader_parameter("player_position", player.global_position)

func _processSonarTime(delta):
	SHADER.set_shader_parameter("time", delta)

func _setSonarPulseTime(time):
	if time < 0:
		SHADER.set_shader_parameter("max_distance", 0)
	else:
		SHADER.set_shader_parameter("max_distance", maxD)
		SHADER.set_shader_parameter("pulse_time", time)

func SetBigFishPositionOnPlayer():
	player = get_tree().get_first_node_in_group("Player")
	$PoissonDeLaFin.global_position = player.global_position
