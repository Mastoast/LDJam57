extends CharacterBody2D

#region Variables
@export
var baseDashForce : float = 100
var strongDashForce : float = 3
var currentDashForce : float = 10

enum State {Idle, Scan, Dash}
var Player_State : State = State.Idle

var latestPosition : Vector2
#endregion

func _ready() -> void:
	latestPosition = position

func _process(_delta: float) -> void:
	if (Player_State == State.Idle):
		look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("ui_select") && Player_State != State.Dash: ## dash debug
		Player_State = State.Dash
		_dash()

func _physics_process(delta: float) -> void:
	if Player_State == State.Dash && move_and_collide(baseDashForce * delta * Vector2.from_angle(rotation)):
		Player_State = State.Idle
		position = latestPosition

func _dash(dashForceMultiplier: float = 1) -> void:
	latestPosition = position
	
	$Timer.start()
	$Timer.timeout.connect(_onDashFinished)

func _onDashFinished() -> void:
	Player_State = State.Idle
