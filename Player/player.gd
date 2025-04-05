extends Node2D

@export
var baseDashForce : float = 10

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("ui_select"):
		_dash()

func _dash(dashForceMultiplier: float = 1) -> void:
	global_position += baseDashForce * dashForceMultiplier * Vector2.from_angle(rotation)
