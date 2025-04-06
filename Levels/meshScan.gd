extends MeshInstance2D

# Internal Variables.
var player : Node2D
var is_running := false

# Play with these variables.
##@export var max_distance := 10.0
@export var speed := 2.0

# Get the reference to the material to pass data to shader parameters.
@onready var SHADER: ShaderMaterial = self.material

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	print_debug(player.name)
	(player as _Player).sendSonarWithTime.connect(_processSonarTime)

func _process(_delta):
	SHADER.set_shader_parameter("player_position", player.global_position)
	##SHADER.set_shader_parameter("max_distance", max_distance)

func _processSonarTime(delta):
	SHADER.set_shader_parameter("time", delta)
