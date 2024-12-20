extends Area2D

@export var propulsion_force = 50

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("can_be_propulse"):
		body.apply_central_impulse(Vector2(cos(rotation_degrees), sin(rotation_degrees)) * propulsion_force) 
