extends MeshInstance2D

# Get the reference to the material to pass data to shader parameters.
@onready var SHADER: ShaderMaterial = self.material

var player : _Player

func _ready():
	player = get_tree().root.get_node("BaseLevel/Player")
	player.sendSonarWithTime.connect(_processSonarTime)
	player.setSonarPulseTime.connect(_setSonarPulseTime)

func _process(_delta):
	SHADER.set_shader_parameter("player_position", player.global_position)

func _processSonarTime(delta):
	SHADER.set_shader_parameter("time", delta)

func _setSonarPulseTime(time):
	SHADER.set_shader_parameter("pulse_time", time)
