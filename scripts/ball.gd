class_name Ball
extends RigidBody2D

@export var ball_gravity: float = 0.2
@export var push_forces_restart: float = 5

var stop_gravity = 0
var last_player_touch_ball

func _on_body_entered(body: Node) -> void:
	if body is Player or body.is_in_group("bullet"):
		last_player_touch_ball = body
		
func stop_ball():
	set_gravity_scale(stop_gravity)
	set_linear_velocity(Vector2.ZERO)
	last_player_touch_ball = null
	
func restart_ball():
	set_gravity_scale(ball_gravity)
	if global_position.x > 0:
		apply_central_force(Vector2(-10, -10) * (push_forces_restart * -1))
		print("right to left")
	else:
		apply_central_force(Vector2(10, 10) * push_forces_restart)
		print("left to right")
