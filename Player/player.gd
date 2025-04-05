extends CharacterBody2D

#region Variables
@export
var baseDashForce : float = 100

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
		latestPosition = position
		Player_State = State.Idle

func _physics_process(delta: float) -> void:
	if Player_State == State.Dash:
		_dash(delta)

func _dash(dashForceMultiplier: float = 1) -> void:
	latestPosition = position
	var col = move_and_collide(baseDashForce * dashForceMultiplier * Vector2.from_angle(rotation))
	if col:
		Player_State = State.Idle
		position = latestPosition
