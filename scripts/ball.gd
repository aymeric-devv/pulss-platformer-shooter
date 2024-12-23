class_name Ball
extends RigidBody2D

@export var ball_gravity: float = 0.2
var stop_gravity = 0

func _on_body_entered(body: Node) -> void:
	if body is Player or body.is_in_group("bullet"):
		print("touch balls")
		
func stop_ball():
	set_gravity_scale(stop_gravity)
	set_linear_velocity(Vector2.ZERO)
	
func restart_ball():
	set_gravity_scale(ball_gravity)
	#apply_central_force(Vector2(10, 5) * 50)
