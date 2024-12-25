class_name Ball
extends RigidBody2D

@export var ball_gravity: float = 0.2 
@export var push_forces_restart: float = 100 # The propulse force that will be applied to the ball when player goals

const STOP_GRAVITY = 0
var last_player_touch_ball

func _on_body_entered(body: Node) -> void:
	if body is Player:
		last_player_touch_ball = body
		
func stop_ball():
	set_gravity_scale(STOP_GRAVITY)
	set_linear_velocity(Vector2.ZERO)
	last_player_touch_ball = null
	
func restart_ball():
	set_gravity_scale(ball_gravity)
	if global_position.x > 0:
		apply_central_force(Vector2(-10, -5) * push_forces_restart)
		
	else:
		apply_central_force(Vector2(10, -5) * push_forces_restart)
