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

var sonarLight = load("res://Player/light_scan_fx.tscn")
##@export var sonarLightBack : PointLight2D
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
		var current_rotation_degrees = fmod(rotation_degrees, 360)
		$Sprite2D.flip_v = current_rotation_degrees > 90 and current_rotation_degrees < 270
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
func _onBigSonar() -> void: _onSonar(.5)

func _onSonar(speedMult : float = 1) -> void:
	var timer = sonarEmissionTime * speedMult
	
	var sL = sonarLight.instantiate()
	get_parent().add_child(sL)
	sL.global_position = global_position
	
	var sonarTween = create_tween()
	sL.scale = Vector2.ZERO
	sonarTween.tween_property(sL, "scale", Vector2(1.0, 1.0), .3 * timer)
	var lightForWalls = sL.get_child(0) as PointLight2D
	var lightBack = sL.get_child(1) as PointLight2D
	sonarTween.tween_property(lightBack, "texture_scale", 50, .7 * timer)
	sonarTween.parallel().tween_property(lightForWalls, "texture_scale", 0, .7 * timer)
	sonarTween.connect("finished", func() -> void: sL.queue_free())
	
	var sonarPulseTween = create_tween()
	setSonarPulseTime.emit(timer)
	sonarPulseTween.tween_method(sendSonarWithTime.emit, 0.0, timer, timer) ## object based shader fx
	sonarPulseTween.connect("finished", func() -> void: sendSonarWithTime.emit(-1.0))
	
	sonarTween.play()
	sonarPulseTween.play()
	
#endregion
