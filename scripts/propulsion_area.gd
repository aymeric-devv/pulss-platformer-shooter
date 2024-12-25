extends Area2D

@export var propulsion_force : float = 5

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("can_be_propulsed"):
		body.apply_central_impulse(Vector2(0, -propulsion_force)) 
