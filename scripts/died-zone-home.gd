extends Area2D

@onready var respawn: Node2D = $"../Respawn"

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.respawn() # body is an instance of player.gd
