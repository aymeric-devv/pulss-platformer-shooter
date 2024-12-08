extends Area2D

@onready var respawn: Node2D = $"../Respawn"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(0.5).timeout
		body.global_position = respawn.global_position
