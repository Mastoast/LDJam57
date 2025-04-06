extends CharacterBody2D
class_name _Player

#region Variables
@export var baseDashForce : float = 1
var currentDashForce : float

enum State {Idle, Scan, Dash}
var Player_State : State = State.Idle

var latestPosition : Vector2

var particleCollision = load("res://Particles/ParticleCollisionWall.tscn")

var sonarEmissionTime = 2.0
#endregion

#region SIGNALS
signal setSonarPulseTime
signal sendSonarWithTime
#endregion

func _ready() -> void:
	latestPosition = position

func _process(_delta: float) -> void:
	if (Player_State == State.Idle):
		look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("ui_select") && Player_State != State.Dash: ## dash debug
		_onSonar()
		
func _physics_process(delta: float) -> void:
	#velocity = Input.get_vector("ui_left", "ui_right","ui_up", "ui_down") * 150
	#move_and_slide()
	if Player_State == State.Dash:
		var collision = move_and_collide(currentDashForce * delta * Vector2.from_angle(rotation))
		if collision:
			Player_State = State.Idle
			var newParticle = particleCollision.instantiate()
			get_parent().add_child(newParticle)
			newParticle.global_position = collision.get_position()
			newParticle.restart()
			position = latestPosition
	 
func _get_position():
	return get_parent().position
	
#region DASH
func _dash(dashForceMultiplier: float = 1, dashTime: float = 1) -> void:
	Player_State = State.Dash
	latestPosition = position
	currentDashForce = baseDashForce * dashForceMultiplier
	$Timer.wait_time = dashTime * .8
	$Timer.start()
	$ParticleBubble/CPUParticles2D.restart()
	
func _onDashFinished() -> void:
	Player_State = State.Idle
#endregion

#region SONAR#
var sonarTween: Tween

func _onBigSonar() -> void: _onSonar(.5)

func _onSonar(speedMult : float = 1) -> void:
	var timer = sonarEmissionTime * speedMult
	setSonarPulseTime.emit(timer)
	if sonarTween: sonarTween.kill()
	sonarTween = create_tween()
	sonarTween.tween_method(sendSonarWithTime.emit, 0.0, timer, timer)
	sonarTween.connect("finished", func(): sendSonarWithTime.emit(-1))
	sonarTween.play()
#endregion
