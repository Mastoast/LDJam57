extends CharacterBody2D
class_name _Player

#region Variables
@export var baseDashForce : float = 1
var currentDashForce : float

enum State {Idle, Scan, Dash}
var Player_State : State = State.Idle

var latestPosition : Vector2

var particleCollision = load("res://Assets/Particles/ParticleCollisionWall.tscn")

var sonarEmissionTime = 2.0

var sonarLight = load("res://Player/light_scan_fx.tscn")
var sonarLight2 = load("res://Player/light_scan_fx2.tscn")

@export_category("Sonar")
@export var generic_sonar_enabled = false
@export var organic_sonar_enabled = false
@export var moveCurve : Curve

#endregion

#region SIGNALS
signal setSonarPulseTime
signal setSonarTwoPulseTime
signal sendSonarWithTime
signal sendSonarTwoWithTime
#endregion

func _ready() -> void:
	latestPosition = position

func _process(_delta: float) -> void:
	if (Player_State == State.Idle):
		look_at(get_global_mouse_position())
		var current_rotation_degrees = abs(fmod(rotation_degrees, 360))
		$Sprite2D.flip_v = current_rotation_degrees > 90 and current_rotation_degrees < 270
	if Input.is_action_just_pressed("ui_select") && Player_State != State.Dash: ## dash debug
		pass##_processOnSonar()

func _physics_process(delta: float) -> void:
	#velocity = Input.get_vector("ui_left", "ui_right","ui_up", "ui_down") * 150
	#move_and_slide()
	if Player_State == State.Dash:
		var collision = move_and_collide(moveCurve.sample(1 - $Timer.time_left / $Timer.wait_time) * currentDashForce * delta * Vector2.from_angle(rotation))
		if collision:
			Player_State = State.Idle
			var newParticle = particleCollision.instantiate()
			get_parent().add_child(newParticle)
			newParticle.global_position = collision.get_position()
			newParticle.restart()
			position = (position + latestPosition) / 2
			$AnimationPlayer.play("bump", -1, 2)

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

func _onBigSonar(speedMult : float) -> void: _processOnSonar(true, speedMult)

func _onSonar(speedMult : float) -> void: _processOnSonar(false, speedMult)

func _processOnSonar(isOrganic : bool = false, speedMult : float = 1) -> void:
	if !isOrganic and !generic_sonar_enabled:
		return
	if isOrganic and !organic_sonar_enabled:
		return
	
	var timer = sonarEmissionTime * speedMult
	
	var sLprefab = sonarLight
	var sendSonarTime = sendSonarWithTime
	var setPulseTime = setSonarPulseTime
	if isOrganic:
		sLprefab = sonarLight2
		sendSonarTime = sendSonarTwoWithTime
		setPulseTime = setSonarTwoPulseTime
	var sL = sLprefab.instantiate()
	print_debug(sL.name)
	
	get_parent().add_child(sL)
	sL.global_position = global_position
	
	var sonarTween = create_tween()
	sL.scale = Vector2.ZERO
	sonarTween.tween_property(sL, "scale", Vector2(1.0, 1.0), .3 * timer)
	
	var lightBack = sL.get_child(1) as PointLight2D
	sonarTween.tween_property(lightBack, "texture_scale", 100, .7 * timer * 2)
	#var lightForWalls = sL.get_child(0) as PointLight2D
	#sonarTween.parallel().tween_property(lightForWalls, "energy", 0.0, .7 * timer * .75).set_ease(Tween.EASE_OUT)
	#sonarTween.tween_property(lightBack, "energy", 0.0, .7 * timer * .75)
	sonarTween.connect("finished", func() -> void: sL.queue_free())
	
	var sonarPulseTween = create_tween()
	setPulseTime.emit(timer)
	sonarPulseTween.tween_method(sendSonarTime.emit, 0.0, timer * .5, timer * .5) ## object based shader fx
	sonarPulseTween.connect("finished", func() -> void:
		sendSonarTime.emit(-1.0)
		setPulseTime.emit(-1.0)
		)
	
	#sonarTween.play()
	sonarPulseTween.play()
	
#endregion
