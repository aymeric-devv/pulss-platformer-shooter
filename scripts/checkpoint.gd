class_name Checkpoint
extends Area2D

@onready var where: Marker2D = $Where

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_respawn_position(global_position)
