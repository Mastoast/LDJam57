extends CharacterBody2D

#region Variables
@export
var baseDashForce : float = 1
var currentDashForce : float

enum State {Idle, Scan, Dash}
var Player_State : State = State.Idle

var latestPosition : Vector2

var particleCollision = load("res://Particles/ParticleCollisionWall.tscn")
#endregion

func _ready() -> void:
	latestPosition = position

func _process(_delta: float) -> void:
	if (Player_State == State.Idle):
		look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("ui_select") && Player_State != State.Dash: ## dash debug
		_dash()
func _get_position():
	return get_parent().position
func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("ui_left", "ui_right","ui_up", "ui_down") *150
	move_and_slide()
	if Player_State == State.Dash:
		var collision = move_and_collide(currentDashForce * delta * Vector2.from_angle(rotation))
		if collision:
			Player_State = State.Idle
			var newParticle = particleCollision.instantiate()
			get_parent().add_child(newParticle)
			newParticle.global_position = collision.get_position()
			newParticle.restart()
			position = latestPosition
	 

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
