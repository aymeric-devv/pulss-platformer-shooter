class_name Ball
extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	if body is Player or body.is_in_group("bullet"):
		print("touch balls")

func set_ball_position(where):
	var xform = get_transform()
	xform.origin.x = where.x
	xform.origin.y = where.y
	
