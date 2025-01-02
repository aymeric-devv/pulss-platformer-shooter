extends RigidBody2D

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node) -> void:
	if body is Ball:
		await get_tree().create_timer(0.1).timeout
		queue_free() # Touched Player !
	else:
		await get_tree().create_timer(2).timeout
		print("explosion")
		queue_free()
