extends AnimatableBody2D

#region Variables
@export
var baseDashForce : float = 1000

enum State {Idle, Scan, Dash}
var Player_State : State = State.Idle

var latestPosition : Vector2
#endregion

func _ready() -> void:
	latestPosition = position

func _process(_delta: float) -> void:
	if (Player_State == State.Idle):
		look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("ui_select", true): ## dash debug
		Player_State = State.Dash
		_dash()

#func _physics_process(_delta: float) -> void:
	#if Player_State == State.Dash:
		#if test_move(transform, Vector2.ZERO):
			#Player_State = State.Idle
			#position = latestPosition

func _dash(dashForceMultiplier: float = 1) -> void:
	latestPosition = position
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	var targetPosition = position + baseDashForce * dashForceMultiplier * Vector2.from_angle(rotation)
	tween.tween_property(self, "position", targetPosition, 1)##.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.finished.connect(_onDashFinished)
	tween.play()

func _onDashFinished() -> void:
	Player_State = State.Idle
