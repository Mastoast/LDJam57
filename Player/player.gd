extends CharacterBody2D
class_name _Player

#region Variables
@export
var baseDashForce : float = 1
var currentDashForce : float

enum State {Idle, Scan, Dash}
var Player_State : State = State.Idle

var latestPosition : Vector2

@export
var moveCurve : Curve
#endregion

#region SIGNALS
var sendSonarWithTime : Signal
#endregion

func _ready() -> void:
	latestPosition = position

func _process(_delta: float) -> void:
	if (Player_State == State.Idle):
		look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("ui_select") && Player_State != State.Dash: ## dash debug
		_dash()

func _physics_process(delta: float) -> void:
	if Player_State == State.Dash && move_and_collide(lerp(Vector2.ZERO, currentDashForce * delta * Vector2.from_angle(rotation), moveCurve.sample(1 / $Timer.time_left))):
		Player_State = State.Idle
		position = latestPosition

#region DASH
func _dash(dashForceMultiplier: float = 1, dashTime: float = 1) -> void:
	Player_State = State.Dash
	latestPosition = position
	currentDashForce = baseDashForce * dashForceMultiplier
	$Timer.wait_time = dashTime * .8
	$Timer.start()

func _onDashFinished() -> void:
	Player_State = State.Idle
#endregion
