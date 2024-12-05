extends RigidBody2D

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node) -> void:
	await get_tree().create_timer(2).timeout
	print("explosion")
	queue_free()
